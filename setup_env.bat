@echo off
REM setup_env.bat - Quick setup script for Windows
REM Run this file to configure OpenCode API key

setlocal enabledelayedexpansion

echo ============================================================
echo Educational Fantasy RPG - Windows Configuration Setup
echo ============================================================
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Python is not installed or not in PATH
    echo.
    echo Please download and install Python from: https://python.org/
    echo Make sure to check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)

echo Python found! Running setup script...
echo.

REM Run the Python setup script
python setup_env.py

if %errorlevel% equ 0 (
    echo.
    echo Setup completed successfully!
    pause
) else (
    echo.
    echo Setup failed!
    pause
    exit /b 1
)
