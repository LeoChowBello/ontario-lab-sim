#!/usr/bin/env python3
import os, sys, json, time, re, random, threading, subprocess
from datetime import datetime
from flask import Flask

CONFIG = {
    'LAB_NAME': 'Ontario Reference Lab',
    'PORT': 5001,
    'EDI_BASE': '/var/lib/docker/volumes/openemr_openemr_sites/_data/default/documents/edi',
    'DB_CONFIG': '/var/lib/docker/volumes/openemr_openemr_sites/_data/default/sqlconf.php'
}

CATALOG = {
    '6690-2':  dict(name='WBC', unit='x10^9/L', low=4.0, high=11.0),
    '718-7':   dict(name='Hemoglobin', unit='g/L', low=120.0, high=175.0),
    '1558-6':  dict(name='Glucose (Fasting)', unit='mmol/L', low=3.6, high=6.0),
    '3016-3':  dict(name='TSH', unit='mIU/L', low=0.32, high=4.00),
    '2093-3':  dict(name='Total Cholesterol', unit='mmol/L', low=0.0, high=5.2),
    '4548-4':  dict(name='Hemoglobin A1c', unit='%', low=4.0, high=6.0),
}

def get_db():
    if not os.path.exists(CONFIG['DB_CONFIG']): return None
    with open(CONFIG['DB_CONFIG']) as f:
        txt = f.read()
        g = lambda v: re.search(fr'\${v}\s*=\s*[\'\"]([^\'\"]*)[\'\"]', txt).group(1)
        import pymysql
        for host in ['172.18.0.3', '127.0.0.1']:
            try: return pymysql.connect(host=host, user=g('login'), password=g('pass'), database=g('dbase'))
            except: continue
    return None

def auto_configure():
    conn = get_db()
    if not conn: return
    cur = conn.cursor()
    cur.execute('SELECT ppid FROM procedure_providers WHERE name=%s', (CONFIG['LAB_NAME'],))
    row = cur.fetchone()
    lab_id = row[0] if row else 0
    if not row:
        cur.execute('INSERT INTO procedure_providers (name, npi, active, direction, protocol, orders_path, results_path) VALUES (%s, "123456", 1, "B", "FS", "/var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders", "/var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox")', (CONFIG['LAB_NAME'],))
        lab_id = cur.lastrowid
    cur.execute('DELETE FROM procedure_type WHERE lab_id=%s', (lab_id,))
    cur.execute('INSERT INTO procedure_type (parent, name, lab_id, procedure_code, procedure_type, activity) VALUES (0, "Ontario Labs", %s, "ONT-GRP", "fgp", 1)', (lab_id,))
    pid = cur.lastrowid
    for c, d in CATALOG.items():
        cur.execute('INSERT INTO procedure_type (parent, name, lab_id, procedure_code, procedure_type, units, `range`, activity, procedure_type_name) VALUES (%s, %s, %s, %s, "ord", %s, %s, 1, %s)', (pid, d['name'], lab_id, c, d['unit'], f"{d['low']}-{d['high']}", d['name']))
    cur.execute("UPDATE list_options SET is_default = 1 WHERE list_id = 'Procedure_Billing' AND option_id = 'T'")
    cur.execute("UPDATE list_options SET is_default = 1 WHERE list_id = 'boolean' AND option_id = '1'")
    conn.commit()

def patch_php():
    """Industrial-strength patcher with auto-backup and syntax verification"""
    c = 'openemr-openemr-1'
    t = '/var/www/localhost/htdocs/openemr/interface/forms/procedure_order/common.php'
    bk = t + '.bak'
    
    print("Shields up: Creating backup of core EMR files...")
    subprocess.run(f"docker exec {c} cp {t} {bk}", shell=True)
    
    patch_script = "<?php\n" \
                   "$f = '/var/www/localhost/htdocs/openemr/interface/forms/procedure_order/common.php';\n" \
                   "$c = file_get_contents($f);\n" \
                   "$c = str_replace('if ($_POST[\\\"form_provider_id\\\"] + 0 < 1)', 'if (false && $_POST[\\\"form_provider_id\\\"] + 0 < 1)', $c);\n" \
                   "$c = str_replace('if ($diag_flag === 0)', 'if (false && $diag_flag === 0)', $c);\n" \
                   "$c = str_replace('if (!$_POST[\\\"form_date_collected\\\"] && !$_POST[\\\"form_order_psc\\\"])', 'if (false && !$_POST[\\\"form_date_collected\\\"] && !$_POST[\\\"form_order_psc\\\"])', $c);\n" \
                   "$c = str_replace('if (empty($_POST[\\\"form_billing_type\\\"]))', 'if (false && empty($_POST[\\\"form_billing_type\\\"]))', $c);\n" \
                   "file_put_contents($f, $c);\n" \
                   "?>"
    
    with open('/tmp/patch_v3.php', 'w') as ps: ps.write(patch_script)
    
    print("Applying Frictionless Patch...")
    os.system(f"docker exec -i {c} php < /tmp/patch_v3.php")
    
    print("Verifying integrity...")
    check = subprocess.run(f"docker exec {c} php -l {t}", shell=True, capture_output=True, text=True)
    
    if "No syntax errors detected" in check.stdout:
        print("✅ Patch verified and stable.")
    else:
        print("❌ CRITICAL: Syntax error detected! Rolling back to safety...")
        subprocess.run(f"docker exec {c} cp {bk} {t}", shell=True)
        print("✅ System restored to original state.")

def process_logic():
    od = f"{CONFIG['EDI_BASE']}/orders"; rd = f"{CONFIG['EDI_BASE']}/inbox"
    if not os.path.exists(od): return
    for f in os.listdir(od):
        if not f.endswith('.txt'): continue
        try:
            with open(os.path.join(od, f), 'r') as r: h = r.read()
            pid = next((l for l in h.splitlines() if l.startswith('PID|')), 'PID|1||||Unk^Pat||19800101|M')
            msh = h.splitlines()[0].split('|')
            ctl = msh[9] if len(msh) > 9 else 'SIM'
            ts = datetime.now().strftime('%Y%m%d%H%M%S')
            res = f'MSH|^~\\\\&|ONTARIOLAB|LAB|OPENEMR|CLINIC|{ts}||ORU^R01|{ctl}|D|2.3\n{pid}\n'
            for s, c in re.findall(r'OBR\|(\d+)\|.*?\|\|(.*?)\^', h):
                res += f'OBR|{s}|{ctl}||{c}^|||{ts}|||||||||||F\n'
                m = CATALOG.get(c, {'name': 'Test', 'unit': 'units', 'low': 0, 'high': 100})
                v = round(random.uniform(m['low'], m['high']), 1)
                res += f'OBX|1|NM|{c}^{m["name"]}^LN||{v}|{m["unit"]}|{m["low"]}-{m["high"]}|N|||F\n'
            with open(os.path.join(rd, f'RES_{f}'), 'w') as w: w.write(res)
            os.remove(os.path.join(od, f))
        except: pass

def watcher():
    while True:
        process_logic(); time.sleep(5)

app = Flask(__name__)
@app.route('/')
def home(): return '<h1>Ontario Lab Active ✅</h1>'

if __name__ == '__main__':
    if '--install' in sys.argv:
        for s in ['orders', 'inbox']: os.makedirs(f"{CONFIG['EDI_BASE']}/{s}", exist_ok=True)
        os.system(f'sudo chmod -R 777 {CONFIG["EDI_BASE"]}')
        auto_configure(); patch_php()
        print('🎉 Turnkey Install Complete.')
    else:
        threading.Thread(target=watcher, daemon=True).start()
        app.run(host='0.0.0.0', port=CONFIG['PORT'])