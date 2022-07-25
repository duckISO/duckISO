@echo off
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause & exit 1
    )
    exit 0
)
title Fix error 2502 and 2503
chcp 65001 >nul
echo This should fix error 2502 and 2503 when installing applications.
pause
cls
for /f "tokens=*" %%a in ('whoami') do (set user=%%a) || echo Failed to set variable for user account!
icacls "C:\Windows\Temp" /grant:r %user%:(OI)(CI)F /grant:r Administrators:(OI)(CI)F /T /Q || echo Failed to set permissions!
echo]
echo Should be done.
pause
exit /b 1