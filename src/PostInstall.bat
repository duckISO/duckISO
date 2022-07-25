@echo off
>nul chcp 65001
:: Colours
set c_reset=[0m
set c_yellow=[38;5;220m
set c_orange=[38;5;208m
set c_white=[97m
title Post Installation Script for duckISO - he3als

:start
:: Credit to server.bat for the duck
echo %c_yellow%     _            _    ___ ____   ___  
echo   __^| ^|_   _  ___^| ^| _^|_ _/ ___^| / _ \    _
echo  / _` ^| ^| ^| ^|/ __^| ^|/ /^| ^|\___ \^| ^| ^| ^| %c_orange%^>%c_yellow%^(%c_white%.%c_yellow%^)__
echo ^| (_^| ^| ^|_^| ^| (__^|   ^< ^| ^| ___) ^| ^|_^| ^|  ^(___/
echo  \__,_^|\__,_^|\___^|_^|\_\___^|____/ \___/ 
echo]
echo This is the post installation script for duckISO, a fork of Atlas.
echo ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────%c_reset%
echo The post install script is about to start.
echo If needed, change your language and regional settings right now.
pause
echo]
echo You also should ensure that tamper protection is disabled, although it already should be.
echo Waiting 2 seconds and then opening the Security app...
timeout /t 2 /nobreak > nul
start "" "windowsdefender:"
pause
goto postinstall

:postinstall
echo Please wait, this may take a moment.
echo Do not close this window or the other window!
set success=
C:\Windows\DuckModules\Apps\nsudo.exe -U:T -P:E -Wait C:\Windows\DuckModules\duck-config.bat /postinstall
:: Read from success.txt
set /p success=<C:\Users\Public\success.txt
:: Check if script finished
if %success% equ true (
	goto success
	) else (
	:: If not, restart script
	echo.
	goto failure
)

:failure
echo POST INSTALL SCRIPT CLOSED!
echo The script was 
echo Launching script again...
echo.
goto start

:success
del /f /q "C:\Users\Public\success.txt"
shutdown /r /f /t 10 /c "Required reboot to apply changes to Windows"
DEL "%~f0"
exit