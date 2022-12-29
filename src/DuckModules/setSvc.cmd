@echo off
set system=true
set setSvcWarning=true
set invalid=false
set standalone=false
set function=false

whoami /user | findstr /i /c:S-1-5-18 >nul || set system=false

:: Check command line arguments, set variables
if [%~3]==[] goto help

if "%~1"=="/f" (
	set message=Invalid command - you can not have /f in the place of the service
	set invalid=true
	goto help
) else (
	if "%~2"=="/f" (
		set message=Invalid command - you can not have /f in the place of the startup type
		set invalid=true
		goto help
	)
)
 
if "%~1"=="/s" (
	set message=Invalid command - you can not have /s in the place of the service
	set invalid=true
	goto help
) else (
	if "%~2"=="/s" (
		set message=Invalid command - you can not have /s in the place of the startup type
		set invalid=true
		goto help
	)
)

set service=%~1
set start=%~2

:loop
if "%~1"=="/f" (set function=true)
if "%~1"=="/s" (set standalone=true)
if "%~1"=="/q" (set setSvcWarning=false)
if "%~1"=="/k" (set killService=true)
 
shift /1
if not [%~1]==[] (goto loop)

:: ------------------------------------------- ::

if "%function%"=="true" (
	if "%standalone%"=="true" (
		set message=The standalone ^(/s^) and ^(/f^) argument can not be used together.
		set invalid=true
		goto help
	)
)

if "%function%"=="true" (goto setSvc)
if "%standalone%"=="true" (goto standalone)

:: Must be invalid if nothing else was detected
set invalid=true
goto help

:: Function
:setSvc
if [%service%]==[] (echo You need to run this with a service/driver to disable. & exit /b 1)
if [%start%]==[] (echo You need to run this with an argument ^(1-5^) to configure the service's startup. & exit /b 1)
if %start% LSS 0 (echo Invalid start value ^(%start%^) for %service%. & exit /b 1)
if %start% GTR 5 (echo Invalid start value ^(%start%^) for %service%. & exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%service%" >nul 2>&1 || (echo The specified service/driver ^(%service%^) is not found. & exit /b 1)
if "%system%"=="false" (
	if not "%setSvcWarning%"=="false" (
		echo WARNING: Not running as System, could fail modifying some services/drivers with an access denied error.
	)
)
reg add "HKLM\System\CurrentControlSet\Services\%service%" /v "Start" /t REG_DWORD /d "%start%" /f > nul || (
	if "%system%"=="false" (echo Failed to set service %service% with start value %start%! Not running as System, access denied?) else (
	echo Failed to set service %service% with start value %start%! Unknown error.)
)
if "%killService%"=="true" (
	sc stop "%service%" >nul 2>&1
	set errorlevel1=%%errorlevel%%
	if not %errorlevel1%==0 (
		if not %errorlevel1%==1062 (
			echo Service/driver '%service%' failed to stop!
			pause
		) else (echo Service/driver '%service%' was already stopped.)
	)
)
exit /b 0

:standalone
if [%service%]==[] (echo You need to run this with a service/driver to disable. & pause & exit /b 1)
if [%start%]==[] (echo You need to run this with an argument ^(1-5^) to configure the service's startup. & pause & exit /b 1)
if %start% LSS 0 (echo Invalid start value ^(%start%^) for %service%. & pause & exit /b 1)
if %start% GTR 5 (echo Invalid start value ^(%start%^) for %service%. & pause & exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%service%" >nul 2>&1 || (echo The specified service/driver ^(%service%^) is not found. & pause & exit /b 1)

:: If TrustedInstaller, goto the actual script
if "%system%"=="true" (goto standalone1)
if "%setSvcWarning%"=="false" (goto powershellElevation)

:nsudoElevation
where nsudo >nul 2>&1
if %errorlevel%==0 (
	set nsudo=nsudo.exe
)
where nsudolg >nul 2>&1
if %errorlevel%==0 (
	set nsudo=nsudolg.exe
)

if defined nsudo (
	cls
	nsudo.exe -U:T -P:E "%~f0" %* && exit /b 0
	echo NSudo elevation failed! Maybe the UAC prompt was declined?
	echo]
	echo Press any key to attempt to use PowerRun instead ^(if installed^)...
	pause > nul
	goto powerRunElevation
) else (goto powerRun)

:powerRunElevation
where powerrun >nul 2>&1
if %errorlevel%==0 (
	set powerrun=powerrun.exe
)
where powerrun_x64 >nul 2>&1
if %errorlevel%==0 (
	set powerrun=powerrun_x64.exe
)

if defined powerrun (
	cls
	%powerrun% "%~f0" %* && exit /b 0
	echo PowerRun elevation failed! Maybe the UAC prompt was declined?
	echo Add PowerRun or NSudo to PATH and run this script again.
	echo]
	echo Press any key to exit...
	pause > nul
	exit /b 1
) else (
	cls
	echo Add PowerRun or NSudo to PATH and run this script again.
	echo Alternatively, run this script as TrustedInstaller yourself.
	echo]
	echo Press any key to exit...
	pause > nul
	exit /b 1
)

:powershellElevation
fltmc >nul 2>&1 || (
    echo Elevating to only admin due to /q argument
    PowerShell -NoProfile Start -Verb RunAs '%~f0' -ArgumentList '%*' 2> nul || (
        echo Elevation to administrator privileges failed.
        pause & exit 1
    )
    exit /b 0
)

:standalone1
if "%start%"=="0" (set startName=Boot)
if "%start%"=="1" (set startName=System)
if "%start%"=="2" (set startName=Automatic)
if "%start%"=="3" (set startName=Manual)
if "%start%"=="4" (set startName=Disabled)
if "%start%"=="5" (set startName=Delayed Start)

cls
echo You are about to set service/driver %service% to the start type '%startName%'.
if "%system%"=="false" (echo WARNING: Not elevated to TrustedInstaller, there can be issues with permissions.)
echo]
echo Press any key to continue in 3 seconds...
timeout /t 3 /nobreak > nul
pause

echo]
reg add "HKLM\System\CurrentControlSet\Services\%service%" /v "Start" /t REG_DWORD /d "%start%" /f > nul || (
	if "%system%"=="false" (
		echo Failed to set service '%service%' with start value '%startName%'! Not running as System, access denied?
		pause & exit /b 1
	) else (
		echo Failed to set service '%service%' with start value '%startName%'! Unknown error.
		pause & exit /b 1
	)
)

if "%killService%"=="false" (goto finish)
sc stop "%service%" > nul
set errorlevel1=%errorlevel%
if not %errorlevel1%==0 (
	if not %errorlevel1%==1062 (
		echo Service/driver '%service%' failed to stop!
		pause
	) else (set alreadyStopped=true)
)

:finish
cls
if %alreadyStopped%==true (
	echo Note: Attempted to stop service/driver, but it was already stopped. 
	echo]
)
echo Done, successfully set service/driver %service% to the start type '%startName%'.
pause
exit /b 0

:help
:: Credit to https://sourcedaddy.com/windows-7/values-for-the-start-registry-entry.html for Start explanations

set error=0
if "%invalid%"=="true" (
	set error=1
	if not defined message (set message=Argument %1 is invalid!)
	echo]
	echo %message%
)

echo]
echo setSvc.cmd "service/driver" "startup" [/s] [/f] [/q] [/k]
echo]
echo Description:
echo     This script can be called as a function (in scripts) or a standalone script to modify
echo     service or driver's startup type in registry. If an error occurs, the errorlevel will
echo     be set to 1. Use speech marks in arguments, and it is recommended to run this script
echo     as TrustedInstaller with NSudo or PowerRun. Do not run this redirect this script
echo     to 'nul', as no errors will be outputed.
echo]
echo     You must specify either /s or /f.
echo]
echo     Set the setSvcWarning variable to false to not warn about not being TrustedInstaller.
echo     Note: Each time you use the function, the variable is reset so it is not spammed.
echo]
echo     This script was made by he3als (on GitHub).
echo]
echo Parameter List:
echo    /s                                  Run as a standalone script and change with user
echo                                        interaction.
echo]
echo    /f                                  Use as a function, where it would be called in
echo                                        another script.
echo]
echo    /k                                  Attempt to stop the service that is being changed.
echo]
echo    /q                                  Ignore if the script is not being ran as System.
echo                                        Instead, attempt to elevate to admin, if not already.
echo                                        Standalone only.
echo]
echo Startup Values:
echo    0 - Boot                            Specifies a driver that is loaded (but not started)
echo                                        by the boot loader. If no errors occur, the driver is
echo                                        started during kernel initialization prior to any
echo                                        non-boot drivers being loaded.
echo]
echo    1 - System                          Specifies a driver that loads and starts during 
echo                                        kernel initialization after drivers with a Start
echo                                        value of 0 have been started.
echo]
echo    2 - Auto Load (auto)                Specifies a driver or service that is initialized at
echo                                        system startup by Session Manager (smss.exe) or the
echo                                        Services Controller (services.exe).
echo]
echo    3 - Load on Demand (manual)         Specifies a driver or service that the Service
echo                                        Control Manager (SCM) will start only on demand. 
echo                                        These drivers have to be started manually by calling
echo                                        a Win32 SCM application programming interface (API),
echo                                        such as the Services snap-in.
echo]
echo    4 - Disable                         Specifies a disabled (not started) driver or service.
echo]
echo    5 - Delayed Start                   Specifies that less-critical services will start 
echo                                        shortly after startup to allow the operating system 
echo                                        to be responsive to the user sooner. This start type 
echo                                        was first introduced in Windows Vista.
exit /b %error%
