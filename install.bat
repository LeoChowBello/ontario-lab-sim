@echo off
echo.
echo ============================================
echo  Ontario Lab Mocklab - Universal Installer
echo ============================================
echo.

REM Detect Docker Compose command (supports both old and new syntax)
set "DOCKER_COMPOSE_CMD="
where docker-compose >nul 2>&1
if %errorlevel% equ 0 (
    set "DOCKER_COMPOSE_CMD=docker-compose"
) else (
    where docker >nul 2>&1
    if %errorlevel% equ 0 (
        docker compose version >nul 2>&1
        if %errorlevel% equ 0 (
            set "DOCKER_COMPOSE_CMD=docker compose"
        )
    )
)

if "%DOCKER_COMPOSE_CMD%"=="" (
    echo ERROR: Docker Compose not found.
    echo Please install Docker Desktop, then try again.
    pause
    exit /b 1
)

echo Step 1: Cleaning up old containers...
%DOCKER_COMPOSE_CMD% -f docker-compose-8.0.x.yml down -v 2>nul

echo Step 2: Starting Docker containers...
echo   - OpenEMR database (MySQL)
echo   - OpenEMR web application
echo   - Lab simulator
echo.

%DOCKER_COMPOSE_CMD% -f docker-compose-8.0.x.yml up -d

if %errorlevel% neq 0 (
    echo ERROR: Docker Compose failed. Make sure Docker is running.
    pause
    exit /b 1
)

echo.
echo Waiting 60 seconds for services to initialize...
timeout /t 60 /nobreak

echo.
echo Step 3: Configuring database and installing tests...
echo.

python3 ontario_lab_turnkey.py --install

if %errorlevel% neq 0 (
    echo ERROR: Installation failed.
    pause
    exit /b 1
)

echo.
echo ============================================
echo  ✅ Installation Complete!
echo ============================================
echo.
echo Your healthcare IT lab is now running.
echo.
echo Opening your browser...
start http://localhost:8082
echo.
echo NEXT STEPS:
echo ============================================
echo.
echo 1. LOGIN (browser should have opened automatically)
echo    Enter your OpenEMR login credentials
echo    (Check docker-compose-8.0.x.yml if you need to verify them)
echo.
echo 2. CREATE A TEST PATIENT
echo    - Click "Patients" menu
echo    - Click "+ New Patient"
echo    - Fill in: John, Doe, DOB: 01/01/1990
echo    - Click "Save Patient"
echo.
echo 3. CREATE A LAB ORDER
echo    - Click the patient name
echo    - Click "Orders" or "New Order"
echo    - Search for: 3016-3 (TSH test)
echo    - Click "Save Order"
echo.
echo 4. WATCH THE MAGIC
echo    - Wait 10-15 seconds
echo    - Refresh your browser
echo    - See the result appear automatically!
echo.
echo THAT'S IT! You just used HL7 messaging like hospitals do.
echo.
echo Note: If browser didn't open, go to: http://localhost:8082
echo.
echo For more help, see: INSTALL.md
echo.
pause
