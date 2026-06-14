#!/bin/bash
echo "🔍 EDI Directory Monitor"
echo "Checking every 2 seconds for lab orders and results..."
echo ""

while true; do
    clear
    echo "=== EDI Directory Monitor ==="
    echo "Time: $(date)"
    echo ""
    
    echo "📁 /orders directory (inbound - lab requests):"
    docker exec openemr-8x-1 bash -c "ls -lh /var/www/localhost/htdocs/openemr/sites/default/documents/edi/orders/ | tail -10" 2>/dev/null || echo "  (empty)"
    
    echo ""
    echo "📁 /inbox directory (outbound - lab results):"
    docker exec openemr-8x-1 bash -c "ls -lh /var/www/localhost/htdocs/openemr/sites/default/documents/edi/inbox/ | tail -10" 2>/dev/null || echo "  (empty)"
    
    echo ""
    echo "🧪 Mocklab simulator status:"
    docker exec openemr-8x-1 ps aux | grep "python3 ontario_lab_turnkey" | grep -v grep && echo "  ✅ Simulator running" || echo "  ❌ Simulator not running"
    
    echo ""
    echo "(Watching... press Ctrl+C to stop)"
    sleep 2
done
