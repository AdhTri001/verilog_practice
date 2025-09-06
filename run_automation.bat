@echo off
REM Verilog Automation Framework - Windows Batch Script
REM Usage: run_automation.bat <config_file.json>

echo Verilog Automation Framework
echo =============================

if "%1"=="" (
    echo Usage: run_automation.bat ^<config_file.json^>
    echo Example: run_automation.bat asg1.json
    exit /b 1
)

if not exist "%1" (
    echo Error: Configuration file not found: %1
    exit /b 1
)

echo Activating virtual environment...
if exist ".venv\Scripts\activate.bat" (
    call .venv\Scripts\activate.bat
) else (
    echo Warning: Virtual environment not found at .venv
    echo Make sure you have created and activated the virtual environment
)

echo Running automation for: %1
python verilog_automation.py %1

echo Done!
pause
