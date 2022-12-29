@echo off
:: duckISO configuration script
:: This is the master script used to configure duckISO
:: duckISO is a fork of AtlasOS - https://github.com/Atlas-OS/Atlas/tree/main/src

:: Made for Windows 11/10 Enterprise Pro
:: -POST after a batch label means that it is ran and made for the post installation

::    _
:: >( . )__
::  (_____/

:: CREDITS, in no order
:: - he3als
:: - Zusier
:: - Amit
:: - Artanis
:: - CYNAR
:: - Canonez
:: - CatGamerOP
:: - EverythingTech
:: - Melody
:: - Revision
:: - imribiy
:: - nohopestage
:: - Timecard
:: - Phlegm
:: - ReviOS
:: - AtlasOS
:: - Winaero
:: - privacy.sexy

:: ------------------------------------------------------------------------------------------------------------------------

:: Version
set version=1.0.1

:: Make sure that the variables are not undefined
set postinstall=0
set settweaks=0

:: Functions
set svc=call :setSvc
set currentuser=%WinDir%\DuckModules\Apps\nsudo.exe -U:E -P:E -Wait
set system=%WinDir%\DuckModules\Apps\nsudo.exe -U:T -P:E -Wait
set fireBlockExe=call :firewallBlockExe

:: Colours
set c_reset=[0m
set c_underline=[4m
set c_black=[30m
set c_red=[31m
set c_green=[32m
set c_yellow=[33m
set c_blue=[34m
set c_magenta=[35m
set c_cyan=[36m
set c_white=[37m

:: Set variables for identifying the OS
:: - %os% - Windows 10 or 11
:: - %releaseid% - release ID (21H2, 22H2, etc...)
:: - %build% - current build of Windows (like 10.0.19044.1889)
for /f "tokens=6 delims=[.] " %%a in ('ver') do (set "win_version=%%a")
if %win_version% lss 22000 (set os=Windows 10) else (set os=Windows 11)
for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (set releaseid=%%a)
for /f "tokens=4-7 delims=[.] " %%a in ('ver') do (set "build=%%a.%%b.%%c.%%d")
set win_version=

:: Elevation
if /i "%~2"=="/skipElevationCheck" goto permSUCCESS
whoami /user | find /i "S-1-5-18" >nul 2>&1
if %errorlevel%==0 (goto permSUCCESS) else (goto permFAIL)

:permSUCCESS
:: Delayed expansion is enabled in case it is needed
SETLOCAL EnableDelayedExpansion

:: Scripts

:: Post-install & re-applying tweaks
if /i "%~1"=="/postinstall"		   goto postinstall-INIT
if /i "%~1"=="/tweaks-POST"		   goto tweaks-POST
:: Notifications
if /i "%~1"=="/dn"         goto notiD
if /i "%~1"=="/en"         goto notiE
:: Animations
if /i "%~1"=="/ad"         goto aniD
if /i "%~1"=="/ae"         goto aniE
:: Search Indexing
if /i "%~1"=="/di"         goto indexD
if /i "%~1"=="/ei"         goto indexE
:: Wi-Fi
if /i "%~1"=="/dw"         goto wifiD
if /i "%~1"=="/ew"         goto wifiE
:: Microsoft Store
if /i "%~1"=="/ds"         goto storeD
if /i "%~1"=="/es"         goto storeE
:: Bluetooth
if /i "%~1"=="/btd"         goto btD
if /i "%~1"=="/bte"         goto btE
:: Hard Drive Prefetching
if /i "%~1"=="/hddd"         goto hddD
if /i "%~1"=="/hdde"         goto hddE
:: DEP (nx)
if /i "%~1"=="/depE"         goto depE
if /i "%~1"=="/depD"         goto depD
if /i "%~1"=="/ssD"         goto SearchStart
if /i "%~1"=="/ssE"         goto enableStart
if /i "%~1"=="/openshell"         goto openshellInstall
:: Remove UWP
if /i "%~1"=="/uwp"			goto uwp
if /i "%~1"=="/uwpE"			goto uwpE
if /i "%~1"=="/mite"			goto mitE
:: Remove Start Layout GPO (Allow Tiles on Start Menu)
if /i "%~1"=="/stico"          goto startlayout
:: Sleep States
if /i "%~1"=="/sleepD"         goto sleepD
if /i "%~1"=="/sleepE"         goto sleepE
:: Idle
if /i "%~1"=="/idled"          goto idleD
if /i "%~1"=="/idlee"          goto idleE
:: Block Microsoft telemetry IPs
if /i "%~1"=="/telemetryIPs"		goto telemetryIPs
:: Xbox
if /i "%~1"=="/xboxU"         goto xboxU
:: Reinstall VC++ redistributable
if /i "%~1"=="/vcreR"         goto vcreR
:: User Account Control
if /i "%~1"=="/uacD"		goto uacD
if /i "%~1"=="/uacE"		goto uacE
:: Workstation Service (SMB)
if /i "%~1"=="/workD"		goto workstationD
if /i "%~1"=="/workE"		goto workstationE
:: Windows Firewall
if /i "%~1"=="/firewallD"		goto firewallD
if /i "%~1"=="/firewallE"		goto firewallE
:: Printing
if /i "%~1"=="/printD"		goto printD
if /i "%~1"=="/printE"		goto printE
:: Data Queue Sizes
if /i "%~1"=="/dataQueueM"		goto dataQueueM
if /i "%~1"=="/dataQueueK"		goto dataQueueK
:: Network
if /i "%~1"=="/netWinDefault"		goto netWinDefault
if /i "%~1"=="/netDuckDefault"		goto netDuckDefault
:: Clipboard History Service (Also required for Snip and Sketch to copy correctly)
if /i "%~1"=="/cbdhsvcD"    goto cbdhsvcD
if /i "%~1"=="/cbdhsvcE"    goto cbdhsvcE
:: VPN
if /i "%~1"=="/vpnD"    goto vpnD
if /i "%~1"=="/vpnE"    goto vpnE
:: Scoop
if /i "%~1"=="/scoop" goto scoop
if /i "%~1"=="/browser" goto browser
if /i "%~1"=="/altsoftware" goto altSoftware
:: Nvidia P-State 0
if /i "%~1"=="/nvpstateD" goto NVPstate
if /i "%~1"=="/nvpstateE" goto revertNVPState
:: Edge (U = uninstall)
if /i "%~1"=="/edgeU" goto edgeU
:: DSCP
if /i "%~1"=="/dscpauto" goto DSCPauto
:: Display Scaling
if /i "%~1"=="/displayscalingd" goto displayScalingD
:: Static IP
if /i "%~1"=="/staticip" goto staticIP
:: Windows Media Player
if /i "%~1"=="/wmpd" goto wmpD
:: Internet Explorer
if /i "%~1"=="/ied" goto ieD
:: Task Scheduler
if /i "%~1"=="/scheduled"  goto scheduleD
if /i "%~1"=="/schedulee"  goto scheduleE
:: Event Log
if /i "%~1"=="/eventlogd" goto eventlogD
if /i "%~1"=="/eventloge" goto eventlogE
:: NVIDIA Display Container LS - he3als
if /i "%~1"=="/nvcontainerD" goto nvcontainerD
if /i "%~1"=="/nvcontainerE" goto nvcontainerE
if /i "%~1"=="/nvcontainerCMD" goto nvcontainerCMD
if /i "%~1"=="/nvcontainerCME" goto nvcontainerCME
:: Network Sharing
if /i "%~1"=="/networksharingE" goto networksharingE
:: Windows Update
if /i "%~1"=="/updateE" goto updateE
if /i "%~1"=="/updateD" goto updateD
if /i "%~1"=="/insiderE" goto insiderE
if /i "%~1"=="/insiderD" goto insiderD
if /i "%~1"=="/WUduckDefault" goto WUduckDefault
:: Defender
if /i "%~1"=="/defenderD" goto defender
:: Telemetry (Firewall)
if /i "%~1"=="/firewallTelemetry" goto firewallTelemetry
if /i "%~1"=="/delFirewallTelemetry" goto delFirewallTelemetry
:: debugging purposes only
if /i "%~1"=="/test"         goto TestPrompt

:argumentFAIL
echo duck-config had no arguements passed to it, either you are launching duck-config directly or the script, "%~nx0" script is broken.
pause & exit /b

:TestPrompt
set /p c="Test with echo on?"
if %c% equ Y echo on
set /p argPrompt="Which script would you like to test? e.g. (:testScript)"
goto %argPrompt%
echo You should not reach this message!
pause
exit

:postinstall-INIT
:: Set codepage to UTF-8 (fixes box drawing characters)
chcp 65001 > nul
echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Post install initialisation...                │
echo ╰───────────────────────────────────────────────╯%c_reset%
:: Maximise the window
powershell -NonInteractive -NoProfile -window maximized -command ""
:: Set post install variable
set postinstall=1
echo Creating logs directory for troubleshooting...
mkdir %WinDir%\DuckModules\logs

SETLOCAL DisableDelayedExpansion

echo Setting DuckModules in PATH...
setx path "%path%;%WinDir%\DuckModules;" -m  >nul
echo Refresh environment variables...
:: To ensure that the PATH variable is updated so that I can set the apps PATH
call %WinDir%\DuckModules\refreshenv.cmd
setx path "%path%;%WinDir%\DuckModules\Apps;" -m  >nul 2>nul
:: Refresh environment variables once more
call %WinDir%\DuckModules\refreshenv.cmd

SETLOCAL EnableDelayedExpansion

:: Breaks setting keyboard language
:: Rundll32.exe advapi32.dll,ProcessIdleTasks
echo Allow everyone to do anything to the DuckModules folder...
echo Allows for easier script editing
icacls %WinDir%\DuckModules /inheritance:r /grant Everyone:F /t > nul

echo Create success.txt to detect if the script has succeeded or not later on...
break>C:\Users\Public\success.txt
echo false > C:\Users\Public\success.txt

:tweaks-POST
if %postinstall%==0 (
	:: Maximise the window
	powershell -NonInteractive -NoProfile -window maximized -command ""
	:: Set codepage to UTF-8 (fixes box drawing characters)
	chcp 65001 > nul
)
set settweaks=1
echo]
:: Install VCRedist AIO package - fixes errors with missing DLLs
call :vcreR

echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Sync time and set to pool.ntp.org...          │
echo ╰───────────────────────────────────────────────╯%c_reset%
echo Use UTC to prevent issues with dual booting operating systems that use it by default
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f > nul
echo Change NTP server from the default Windows server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" > nul
sc queryex "w32time"|Find "STATE"|Find /v "RUNNING"||(
    net stop w32time
    net start w32time
) >nul 2>nul
echo Resync time to pool.ntp.org
w32tm /config /update > nul
w32tm /resync > nul
sc stop W32Time > nul
sc config W32Time start=disabled > nul

echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Disable tasks...							     │
echo │ Some tasks may not exist						 │
echo ╰───────────────────────────────────────────────╯%c_reset%
:: All of the tasks disabled here will eventually be researched into
for %%a in (
	"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
	"\Microsoft\Windows\Windows Error Reporting\QueueReporting"
	"\Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate"
	"\Microsoft\Windows\DiskFootprint\Diagnostics"
	"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
	"\Microsoft\Windows\Application Experience\StartupAppTask"
	"\Microsoft\Windows\Autochk\Proxy"
	"\Microsoft\Windows\Application Experience\PcaPatchDbTask"
	"\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask"
	"\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"
	"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
	"\Microsoft\Windows\Defrag\ScheduledDefrag"
	"\Microsoft\Windows\DiskFootprint\StorageSense"
	"\Microsoft\Windows\Registry\RegIdleBackup"
	"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"
	"\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"
	"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"
	"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon"
	"\Microsoft\Windows\StateRepository\MaintenanceTasks"
	"\Microsoft\Windows\UPnP\UPnPHostConfig"
	"\Microsoft\Windows\RetailDemo\CleanupOfflineContent"
	"\Microsoft\Windows\Shell\FamilySafetyMonitor"
	"\Microsoft\Windows\InstallService\SmartRetry"
	"\Microsoft\Windows\International\Synchronize Language Settings"
	"\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
	"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"
	"\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia"
	"\Microsoft\Windows\Printing\EduPrintProv"
	"\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"
	"\Microsoft\Windows\Ras\MobilityManager"
	"\Microsoft\Windows\PushToInstall\LoginCheck"
	"\Microsoft\Windows\Time Synchronization\SynchronizeTime"
	"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
	"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"
	"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
	"\Microsoft\Windows\WaaSMedic\PerformRemediation"
	"\Microsoft\Windows\DiskCleanup\SilentCleanup"
	"\Microsoft\Windows\Diagnosis\Scheduled"
	"\Microsoft\Windows\Wininet\CacheTask"
	"\Microsoft\Windows\Device Setup\Metadata Refresh"
	"\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"
	"\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
	"\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
	"\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
	"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
	"\Microsoft\Windows\Device Information\Device"
	"\Microsoft\Windows\Device Information\Device User"
	"\Microsoft\Windows\Application Experience\ProgramDataUpdater"
	"\Microsoft\Windows\Application Experience\AitAgent" 2>nul
	"\Microsoft\Windows\Maps\MapsUpdateTask"
	"\Microsoft\Windows\Maps\MapsToastTask"
	"\Microsoft\Windows\HelloFace\FODCleanupTask"
) do (
	echo Disabling %%a
	schtasks /Change /Disable /TN %%a > nul
)

:tweaks2-POST
echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Quality of Life...                            │
echo ╰───────────────────────────────────────────────╯%c_reset%



goto services_and_drivers_backup1-POST

:services_and_drivers_backup1-POST
echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Services and drivers config and backup...     │
echo ╰───────────────────────────────────────────────╯%c_reset%
:: Backup default or current Windows Services and Drivers
:: Replace / with - in %date% - file name limiation
set newdate=%date:/=-%
:: Replace : with . in %time% - file name limiation
set newtime=%time::=.%

if %postinstall%==1 (
	echo Backing up default Windows services...
) else (
	echo Backing up current services configuration...
)

:: Services
set name=Services
set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\%name% - %newdate% - %newtime%.reg"
if %postinstall%==1 set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\Win Default Services.reg"
:: set filename="C:%HOMEPATH%\Desktop\Atlas\Troubleshooting\Services\Default Windows Services.reg"
echo Windows Registry Editor Version 5.00 >> %filename%
echo] >> %filename%
for /f "skip=1" %%i in ('wmic service get Name^| findstr "[a-z]"^| findstr /V "TermService"') do (
	set svc=%%i
	set svc=!svc: =!
	for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!" /t REG_DWORD /s /c /f "Start" /e^| findstr "[0-4]$"') do (
		set /A start=%%i
		echo !start!
		echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!] >> %filename%
		echo "Start"=dword:0000000!start! >> %filename%
		echo. >> %filename%
	)
) >nul 2>&1

echo]
if %postinstall%==1 (
	echo Backing up default Windows drivers...
) else (
	echo Backing up current drivers configuration...
)
:: Drivers
set name=Drivers
set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\%name% - %newdate% - %newtime%.reg"
if %postinstall%==1 set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\Win Default Drivers.reg"
:: set filename="C:%HOMEPATH%\Desktop\Atlas\Troubleshooting\Services\Default Windows Drivers.reg"
echo Windows Registry Editor Version 5.00 >> %filename%
echo] >> %filename%
for /f "delims=," %%i in ('driverquery /FO CSV') do (
	set svc=%%~i
	for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!" /t REG_DWORD /s /c /f "Start" /e^| findstr "[0-4]$"') do (
		set /A start=%%i
		echo !start!
		echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!] >> %filename%
		echo "Start"=dword:0000000!start! >> %filename%
		echo. >> %filename%
	)
) >nul 2>&1

:services_and_drivers-POST
set svc=call :setSvc

echo]
echo Modifying services startup...
%svc% AppIDSvc 4
%svc% mrxsmb10 4
%svc% AppVClient 4
%svc% AppXSvc 3
%svc% BthAvctpSvc 4
%svc% cbdhsvc 4
%svc% CDPSvc 4
%svc% CryptSvc 3
%svc% defragsvc 3
%svc% diagnosticshub.standardcollector.service 4
%svc% diagsvc 4
%svc% DispBrokerDesktopSvc 4
%svc% DisplayEnhancementService 4
%svc% DoSvc 3
%svc% DPS 4
%svc% DsmSvc 3
:: Can cause issues with Snip & Sketch
:: %svc% DsSvc 4
%svc% Eaphost 3
:: Security, Edge is still enabled but not running in the background
:: %svc% edgeupdate 4
:: %svc% edgeupdatem 4
%svc% EFS 3
%svc% fdPHost 4
%svc% FDResPub 4
%svc% FontCache 4
%svc% FontCache3.0.0.0 4
%svc% icssvc 4
%svc% IKEEXT 4
%svc% InstallService 3
%svc% iphlpsvc 4
%svc% IpxlatCfgSvc 4
:: Causes issues with NVCleanstall's driver telemetry tweak
:: %svc% KeyIso 4
%svc% KtmRm 4
%svc% LanmanServer 4
%svc% LanmanWorkstation 4
%svc% lmhosts 4
%svc% MSDTC 4
%svc% NetTcpPortSharing 4
%svc% PcaSvc 4
%svc% PhoneSvc 4
%svc% QWAVE 4
%svc% RasMan 4
%svc% SharedAccess 4
%svc% ShellHWDetection 4
%svc% SmsRouter 4
%svc% Spooler 4
%svc% sppsvc 3
%svc% SSDPSRV 4
%svc% SstpSvc 4
%svc% SysMain 4
:: Doesn't use that much resources, breaks setting themes
:: %svc% Themes 4
%svc% UsoSvc 3
%svc% VaultSvc 4
%svc% W32Time 4
%svc% WarpJITSvc 4
%svc% WdiServiceHost 4
%svc% WdiSystemHost 4
%svc% Wecsvc 4
%svc% WEPHOSTSVC 4
%svc% WinHttpAutoProxySvc 4
%svc% Wcmsvc 4
%svc% WPDBusEnum 4
%svc% WSearch 4
%svc% wuauserv 3
:: These are normally stripped from Atlas or are just extra stuff
%svc% AJRouter 4
%svc% AxInstSV 4
%svc% WbioSrvc 4
%svc% dmwappushservice 4
%svc% WerSvc 4
%svc% GraphicsPerfSvc 4
%svc% lfsvc 4
%svc% wlpasvc 4
%svc% WMPNetworkSvc 4
%svc% PhoneSvc 4
%svc% TermService 4
%svc% UmRdpService 4
%svc% DiagTrack 4
%svc% UnistoreSvc 4
%svc% OneSyncSvc 4
%svc% MapsBroker 4
%svc% RetailDemo 4
%svc% PimIndexMaintenanceSvc 4
%svc% RetailDemo 4
%svc% UserDataSvc 4
:: Disable sync center services
%svc% CSC 4
%svc% CscService 4
:: Text messaging
%svc% MessagingService 4
%svc% TrkWks 4
:: Coordinates execution of background work for WinRT application
:: %svc% TimeBrokerSvc
:: Breaks Task Scheduler
%svc% CDPUserSvc 4
:: Miracast stuff
%svc% DevicePickerUserSvc 4
%svc% DevicesFlowUserSvc 4
:: Disable Volume Shadow Copy Service (breaks System Restore and Windows Backup)
:: %svc% VSS 4

echo]
echo Modifying drivers startup...
%svc% 3ware 4
%svc% ADP80XX 4
%svc% AmdK8 4
%svc% arcsas 4
%svc% AsyncMac 4
%svc% Beep 4
%svc% bindflt 4
%svc% buttonconverter 4
%svc% CAD 4
%svc% cdfs 4
%svc% CimFS 4
%svc% circlass 4
%svc% cnghwassist 4
%svc% CompositeBus 4
%svc% Dfsc 4
%svc% ErrDev 4
%svc% fdc 4
%svc% flpydisk 4
:: Disables BitLocker - required for disk management and msconfig
:: %svc% fvevol 4
:: Breaks installing Store Apps to different disk (now disabled via store script)
:: %svc% FileInfo 4
:: %svc% FileCrypt 4
%svc% GpuEnergyDrv 4
%svc% mrxsmb 4
%svc% mrxsmb20 4
%svc% NdisVirtualBus 4
%svc% nvraid 4
%svc% PEAUTH 4
%svc% QWAVEdrv 4
:: Set to manual instead of disabling (fixes WSL), thanks Phlegm!
%svc% rdbss 3
%svc% rdyboost 4
%svc% KSecPkg 4
%svc% mrxsmb20 4
%svc% mrxsmb 4
%svc% srv2 4
%svc% sfloppy 4
%svc% SiSRaid2 4
%svc% SiSRaid4 4
%svc% Tcpip6 4
%svc% tcpipreg 4
%svc% Telemetry 4
%svc% udfs 4
%svc% umbus 4
%svc% VerifierExt 4
:: Breaks Dynamic Disks
:: %svc% volmgrx 4
%svc% vsmraid 4
%svc% VSTXRAID 4
:: Breaks various store games, erroring with "Filter not found"
:: %svc% wcifs 4
%svc% wcnfs 4
%svc% WindowsTrustedRTProxy 4

echo]
echo Removing services/driver dependencies
reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f > nul

reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "volsnap" /f > nul

:services_and_drivers_backup2-POST
:: Backup duckISO Services and Drivers
if %postinstall%==0 goto tweaks3-POST

echo]
echo Backing up default duckISO services...
:: Services
set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\duckISO Services.reg"
echo Windows Registry Editor Version 5.00 >> %filename%
echo] >> %filename%
for /f "skip=1" %%i in ('wmic service get Name^| findstr "[a-z]"^| findstr /V "TermService"') do (
	set svc=%%i
	set svc=!svc: =!
	for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!" /t REG_DWORD /s /c /f "Start" /e^| findstr "[0-4]$"') do (
		set /A start=%%i
		echo !start!
		echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!] >> %filename%
		echo "Start"=dword:0000000!start! >> %filename%
		echo. >> %filename%
	)
) >nul 2>&1

echo]
echo Backing up default duckISO drivers...
:: Drivers
set filename="C:\Users\Public\Desktop\duckISO\Troubleshooting\Services\duckISO Drivers.reg"
echo Windows Registry Editor Version 5.00 >> %filename%
echo] >> %filename%
for /f "delims=," %%i in ('driverquery /FO CSV') do (
	set svc=%%~i
	for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!" /t REG_DWORD /s /c /f "Start" /e^| findstr "[0-4]$"') do (
		set /A start=%%i
		echo !start!
		echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\!svc!] >> %filename%
		echo "Start"=dword:0000000!start! >> %filename%
		echo. >> %filename%
	)
) >nul 2>&1

:tweaks3-POST
echo]
echo Even more tweaks
echo ------------------------



echo]
echo Explorer
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v " " /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "LinkResolveIgnoreLinkInfo" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveSearch" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoResolveTrack" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInternetOpenWith" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "DisallowShaking" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSyncProviderNotifications" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ListviewShadow" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f > nul
echo]
echo Turn off the "Order Prints" picture task
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoOnlinePrintsWizard" /t REG_DWORD /d 1 /f > nul
echo]
echo Disable the file and folder Publish to Web option
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoPublishingWizard" /t REG_DWORD /d 1 /f > nul

echo]
echo Misc
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "TailoredExperiencesWithDiagnosticDataEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v "ShowedToastAtLevel" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Diagnostics\Performance" /v "DisableDiagnosticTracing" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v "ScenarioExecutionEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Content Delivery Manager
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314563Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d "0" /f > nul

:tweaks4-POST

echo]
echo Even more tweaks?
echo -----------------------------

echo]
echo Edge
reg add "HKLM\Software\Policies\Microsoft\Windows\EdgeUI" /v "DisableMFUTracking" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\Software\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\FlipAhead" /v "FPEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "ShowSearchSuggestionsGlobal" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "Use FormSuggest" /t REG_SZ /d "no" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "DoNotTrack" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v "OptimizeWindowsSearchResultsForScreenReaders" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Privacy" /v "EnableEncryptedMediaExtensions" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI" /v "EnableCortana" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\ServiceUI\ShowSearchHistory" /ve /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "LocalProvidersEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AddressBarMicrosoftSearchInBingProviderEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "EdgeShoppingAssistantEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ResolveNavigationErrorsUseWebService" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AlternateErrorPagesEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "NetworkPredictionOptions" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PersonalizationReportingEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "PaymentMethodQueryEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "SearchSuggestEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "ConfigureDoNotTrack" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Edge" /v "AutofillAddressEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Browser" /v "AllowAddressBarDropdown" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AutofillCreditCardEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "UserFeedbackAllowed" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t REG_DWORD /d "0" /f > nul












:tweaks5-POST
echo]
echo Hardening...
echo --------------------------------
:: LARGELY based on https://gist.github.com/ricardojba/ecdfe30dadbdab6c514a530bc5d51ef6

echo]
echo General hardening
:: Prevent Kerberos from using DES or RC4
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v "SupportedEncryptionTypes" /t REG_DWORD /d "2147483640" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v "DisableSmartNameResolution" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v "DisableParallelAandAAAA" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "IGMPLevel" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v "EnableICMPRedirect" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v "DisableIPSourceRouting" /t REG_DWORD /d "2" /f > nul



echo]
echo Prevent Edge from running in background
reg add "HKLM\Software\Policies\Microsoft\Edge" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Edge/IE hardening
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SitePerProcess" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLVersionMin" /t REG_SZ /d "tls1.2^@" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "NativeMessagingUserLevelHosts" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverrideForFiles" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d "0" /f > nul
:: Enable Notifications in IE when a site attempts to install software
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer" /v "SafeForScripting" /t REG_DWORD /d "0" /f > nul

:tweaks6-POST
echo]
echo Context menu ^& some QoL tweaks
echo -----------------------------

:: Disable Defender, already disabled but not completely
if %postinstall%==1 (
	echo Disabling Defender
	echo -----------------------------
	call :defender2
)
choice /c:yn /n /m "Would you like to disable Defender? [Y/N]"
if %errorlevel%==1 (
	echo Disabling Defender
	echo -----------------------------
	call :defender2
)
if %errorlevel%==2 goto tweaksfinish

:tweaksfinish
if %postinstall%==1 (
	:: Write to script log file
	echo This log keeps track of which scripts have been run. This is never transfered to an online resource and stays local. > %WinDir%\DuckModules\logs\userScript.log
	echo -------------------------------------------------------------------------------------------------------------------- >> %WinDir%\DuckModules\logs\userScript.log
)
echo]
echo Enable Windows Update
echo Uses a custom configuration
echo -----------------------------
call :updateE2
call :WUduckDefault2

:: clear false value
break>C:\Users\Public\success.txt
echo true > C:\Users\Public\success.txt
echo]
:: Replace / with - in %date% - file name limiation
set newdate=%date:/=-%
:: Replace : with . in %time% - file name limiation
set newtime=%time::=.%

echo]
echo Making a log of the post install in the logs folder called "Post install log - %newdate% %newtime%.txt"
powershell -NoProfile -EP Unrestricted -Command "%WinDir%\DuckModules\Get-ConsoleAsText.ps1" > "%WinDir%\DuckModules\logs\Post install log - %newdate% %newtime%.txt"

echo Done, Defender should of been disabled and Windows Update should be enabled with policies to improve QoL.
echo All of the other post install tweaks should be done too.
echo You can re-apply these tweaks after a Windows Update with the 'Re-apply post-install tweaks' script in the root of the duckISO desktop folder.
echo You should go through the folder on the desktop and disable/enable what you want.
pause
exit

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Scripts												 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:notiD
sc config WpnService start=disabled
sc stop WpnService >nul 2>nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
if %ERRORLEVEL%==0 echo %date% - %time% Notifications Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:notiE
sc config WpnUserService start=auto
sc config WpnService start=auto
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "0" /f
if %ERRORLEVEL%==0 echo %date% - %time% Notifications Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:indexD
sc config WSearch start=disabled
sc stop WSearch >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Search Indexing Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:indexE
sc config WSearch start=delayed-auto
sc start WSearch >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Search Indexing Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:wifiD
echo Applications like Store and Spotify may not function correctly when disabled. If this is a problem, enable the wifi and restart the computer.
sc config WlanSvc start=disabled
sc config vwififlt start=disabled
set /P c="Would you like to disable the Network Icon? (disables 2 extra services) [Y/N]: "
if /I "%c%" EQU "N" goto wifiDskip
sc config netprofm start=disabled
sc config NlaSvc start=disabled

:wifiDskip
if %ERRORLEVEL%==0 echo %date% - %time% Wi-Fi Disabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1"=="int" goto :EOF
goto finish

:wifiE
sc config netprofm start=demand
sc config NlaSvc start=auto
sc config WlanSvc start=demand
sc config vwififlt start=system
:: If wifi is still not working, set wlansvc to auto
ping -n 1 -4 1.1.1.1 |Find "Failure"|(
    sc config WlanSvc start=auto
)
if %ERRORLEVEL%==0 echo %date% - %time% Wi-Fi Enabled...>> %WinDir%\DuckModules\logs\userScript.log
sc config eventlog start=auto
echo %date% - %time% EventLog enabled as Wi-Fi dependency...>> %WinDir%\DuckModules\logs\userscript.log
goto finish

:storeD
echo This will break a majority of UWP apps and their deployment.
echo Extra note: This breaks the "about" page in settings. If you require it, enable the AppX service.
:: This includes Windows Firewall, I only see the point in keeping it because of Store.
:: If you notice something else breaks when firewall/store is disabled please open an issue.
pause
:: Detect if user is using a Microsoft Account
powershell -NoProfile -Command "Get-LocalUser | Select-Object Name,PrincipalSource"|findstr /C:"MicrosoftAccount" >nul 2>&1 && set MSACCOUNT=YES || set MSACCOUNT=NO
if "%MSACCOUNT%"=="NO" ( sc config wlidsvc start=disabled ) ELSE ( echo "Microsoft Account detected, not disabling wlidsvc..." )
:: Disable the option for Windows Store in the "Open With" dialog
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
:: Block Access to Windows Store
reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f
sc config InstallService start=disabled
:: Insufficent permissions to disable
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
sc config mpssvc start=disabled
sc config wlidsvc start=disabled
sc config AppXSvc start=disabled
sc config BFE start=disabled
sc config TokenBroker start=disabled
sc config LicenseManager start=disabled
sc config AppXSVC start=disabled
sc config ClipSVC start=disabled
sc config FileInfo start=disabled
sc config FileCrypt start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Microsoft Store Disabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish

:storeE
:: Enable the option for Windows Store in the "Open With" dialog
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0" /f
:: Allow Access to Windows Store
reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "0" /f
sc config InstallService start=demand
:: Insufficent permissions to enable through SC
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "3" /f
sc config mpssvc start=auto
sc config wlidsvc start=demand
sc config AppXSvc start=demand
sc config BFE start=auto
sc config TokenBroker start=demand
sc config LicenseManager start=demand
sc config wuauserv start=demand
sc config AppXSVC start=demand
sc config ClipSVC start=demand
sc config FileInfo start=boot
sc config FileCrypt start=system
if %ERRORLEVEL%==0 echo %date% - %time% Microsoft Store Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:btD
sc config BthAvctpSvc start=disabled
sc stop BthAvctpSvc >nul 2>nul
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "4" /f
  sc stop %%~nI
)
sc config CDPSvc start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Bluetooth Disabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish

:btE
sc config BthAvctpSvc start=auto
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "2" /f
)
sc config CDPSvc start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Bluetooth Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:cbdhsvcD
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "4" /f
)
:: TODO: check if can be set to demand
sc config DsSvc start=disabled
%currentuser% reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f
if %ERRORLEVEL%==0 echo %date% - %time% Clipboard History Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:cbdhsvcE
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "3" /f
)
sc config DsSvc start=auto
%currentuser% reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d "1" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /f >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Clipboard History Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:hddD
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
sc config SysMain start=disabled
sc config FontCache start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Hard Drive Prefetch Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:hddE
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "3" /f
sc config SysMain start=auto
sc config FontCache start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Hard Drive Prefetch Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:depE
powershell -NoProfile set-ProcessMitigation -System -Enable DEP
powershell -NoProfile set-ProcessMitigation -System -Enable EmulateAtlThunks
bcdedit /set nx OptIn
:: Enable CFG for Valorant related processes
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
  powershell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)
if %ERRORLEVEL%==0 echo %date% - %time% DEP Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:depD
echo If you get issues with some anti-cheats, please re-enable DEP.
powershell -NoProfile set-ProcessMitigation -System -Disable DEP
powershell -NoProfile set-ProcessMitigation -System -Disable EmulateAtlThunks
bcdedit /set nx AlwaysOff
if %ERRORLEVEL%==0 echo %date% - %time% DEP Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:SearchStart
IF EXIST "C:\Program Files\Open-Shell" goto existS
IF EXIST "C:\Program Files (x86)\StartIsBack" goto existS
echo It seems Open-Shell nor StartIsBack are installed. It is HIGHLY recommended to install one of these before running this due to the startmenu being removed.
pause

:edgeU
setlocal DisableDelayedExpansion
:: Uninstalls Microsoft Edge and optionally replaces it with LibreWolf/Brave
echo This will uninstall Microsoft Edge along with the old UWP version (even though it should already be stripped) and it will uninstall related apps.
echo This will not uninstall Edge WebView, because it might be needed for some stuff to function within Windows 11.
echo Here's exactly what will be uninstalled:
echo - Cloud Experience Host app (breaks Windows Hello password/PIN sign-in options, and Microsoft cloud/corporate sign in)
echo - ChxApp app
echo - Content Delivery Manager app (automatically installs apps)
echo - Assigned Access Lock App
echo - Capture Picker app
echo - Microsoft PPI Projection app
echo - Win32 Web View Host app / Desktop App Web Viewer
echo - Microsoft Edge (Legacy) app
echo - Microsoft Edge (Legacy) Dev Tools Client app
echo]
echo NOTE: EdgeUpdate will also be disabled.
echo Major credit to privacy.sexy for uninstalling Edge and credit to ReviOS for the concept of replacing Edge's assocations.
echo Waiting 10 seconds to allow you time to read...
timeout /t 10 /nobreak > nul
pause
echo]
echo Killing all Edge processes...
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
taskkill /f /im msedge.exe >nul 2>&1
echo]
echo Stopping services...
sc stop edgeupdate > nul
sc stop edgeupdatem > nul
sc stop MicrosoftEdgeElevationService > nul
echo Uninstalling Chromium Edge...
for /f "delims=" %%a in ('where /r "C:\Program Files (x86)\Microsoft\Edge\Application" *setup.exe*') do (if exist "%%a" (%%a --uninstall --system-level --verbose-logging --force-uninstall))
echo]
echo Remove residual registry keys and files
echo If the command failed above, this should clean everything up... hopefully...
for /f "tokens=*" %%a in ('whoami') do (set user=%%a)
icacls "C:\Program Files (x86)\Microsoft\Edge" /grant:r %user%:(OI)(CI)F /grant:r Administrators:(OI)(CI)F /T /Q
erase /f /s /q "C:\Program Files (x86)\Microsoft\Edge" > nul
reg delete "HKLM\Software\RegisteredApplications" /v "Microsoft Edge" /f > nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f > nul
reg delete "HKLM\Software\WOW6432Node\Clients\StartMenuInternet\Microsoft Edge" /f > nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f > nul
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths\msedge.exe" /f > nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Edge" /f > nul
reg delete "HKLM\Software\Clients\StartMenuInternet\Microsoft Edge" /f > nul
del /q /f "C:\Users\Public\Desktop\Microsoft Edge.lnk" >nul
del /q /f "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" > nul
%svc% MicrosoftEdgeElevationService 4 > nul
sc delete MicrosoftEdgeElevationService > nul
:: Prevent it from coming back - might anwyays... oh well... :(
reg add "HKLM\SOFTWARE\Microsoft\EdgeUpdate" /v "DoNotUpdateToEdgeWithChromium" /t REG_DWORD /d "1" /f > nul
echo]
echo Disable EdgeUpdate...
sc stop edgeupdate > nul
sc stop edgeupdatem > nul
%svc% edgeupdate 4 > nul
%svc% edgeupdatem 4 > nul
reg copy "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update Old" /s /f > nul
reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f > nul
takeown /f "C:\Program Files (x86)\Microsoft\EdgeUpdate" /r /d y > nul
icacls "C:\Program Files (x86)\Microsoft\EdgeUpdate" /grant Administrators:(OI)(CI)F /t > nul
ren "C:\Program Files (x86)\Microsoft\EdgeUpdate" "DisabledEdgeUpdate" > nul:: schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
echo]
echo Disable tasks
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateTaskMachineUA" >nul 2>nul

:: Disable all perodic network activity
reg add "HKLM\SOFTWARE\Policies\Microsoft\EdgeUpdate" /v "AutoUpdateCheckPeriodMinutes" /t REG_DWORD /d "0" /f > nul
echo]
echo Disable tasks
schtasks /Change /Disable /TN "\MicrosoftEdgeShadowStackRollbackTask" > nul
schtasks /Change /Disable /TN "\MicrosoftEdgeUpdateBrowserReplacementTask" > nul
echo]
echo Uninstalling UWP apps...
echo These might already be stripped.
echo Microsoft Edge (Legacy) app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdge'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Microsoft Edge (Legacy) Dev Tools Client app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdgeDevToolsClient'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Win32 Web View Host app / Desktop App Web Viewer
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Win32WebViewHost'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Microsoft PPI Projection app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.PPIProjection'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Assigned Access Lock App app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.AssignedAccessLockApp'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Capture Picker app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.CapturePicker'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Content Delivery Manager app (automatically installs apps)
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ContentDeliveryManager'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo ChxApp app
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.Apprep.ChxApp'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Cloud Experience Host app (breaks Windows Hello password/PIN sign-in options, and Microsoft cloud/corporate sign in)
powershell -NoProfile -ExecutionPolicy Unrestricted -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.CloudExperienceHost'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo]
echo Would you like to replace Edge's default assocations/protocols with LibreWolf or Brave?
echo Only the default installation path works for LibreWolf and Brave.
choice /c elb /m "Would you like to (e)xit, use (L)ibreWolf or (B)rave?" /n
if %errorlevel%==1 exit /b
if %errorlevel%==2 goto librewolfE
if %errorlevel%==3 goto braveE
:librewolfE
:: LibreWolf (E = Edge) (associations for replacing Edge)
if not exist "C:\Program Files\LibreWolf\librewolf.exe" goto librewolfES
reg add "HKCR\MSEdgeHTM" /ve /t REG_SZ /d "LibreWolf HTML Document" /f > nul
reg add "HKCR\MSEdgeHTM" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgeHTM\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeHTM\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeMHT" /ve /t REG_SZ /d "LibreWolf MHT Document" /f > nul
reg add "HKCR\MSEdgeMHT" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgeMHT\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeMHT\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgePDF" /ve /t REG_SZ /d "LibreWolf PDF Document" /f > nul
reg add "HKCR\MSEdgePDF" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgePDF\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgePDF\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
echo]
echo Should be completed.
pause && exit /b
:librewolfES
:: LibreWolf (E = Edge) (associations for replacing Edge) (S = Scoop)
if not exist "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe" goto edgeF
reg add "HKCR\MSEdgeHTM" /ve /t REG_SZ /d "LibreWolf (Scoop) HTML Document" /f > nul
reg add "HKCR\MSEdgeHTM" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationIcon" /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgeHTM\DefaultIcon" /ve /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\shell\open\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeHTM\shell\runas\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeMHT" /ve /t REG_SZ /d "LibreWolf (Scoop) MHT Document" /f > nul
reg add "HKCR\MSEdgeMHT" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationIcon" /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgeMHT\DefaultIcon" /ve /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\shell\open\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgeMHT\shell\runas\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgePDF" /ve /t REG_SZ /d "LibreWolf (Scoop) PDF Document" /f > nul
reg add "HKCR\MSEdgePDF" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "AppUserModelId" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationIcon" /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationName" /t REG_SZ /d "LibreWolf" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationDescription" /t REG_SZ /d "LibreWolf - A fork of Firefox, with improved privacy, security and freedom" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationCompany" /t REG_SZ /d "LibreWolf Community" /f > nul
reg add "HKCR\MSEdgePDF\DefaultIcon" /ve /t REG_SZ /d "%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\shell\open\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
reg add "HKCR\MSEdgePDF\shell\runas\command" /ve /t REG_SZ /d "\"%USERPROFILE%\scoop\apps\librewolf\current\LibreWolf\librewolf.exe\" -osint -url \"%%1\"" /f > nul
echo]
echo Should be completed.
pause && exit /b
:braveE
:: Brave (E = Edge) (associations for replacing Edge)
if not exist "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe" goto edgeF
reg add "HKCR\MSEdgeHTM" /ve /t REG_SZ /d "Brave HTML Document" /f > nul
reg add "HKCR\MSEdgeHTM" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationName" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationDescription" /t REG_SZ /d "Access the Internet" /f > nul
reg add "HKCR\MSEdgeHTM\Application" /v "ApplicationCompany" /t REG_SZ /d "Brave Software Inc" /f > nul
reg add "HKCR\MSEdgeHTM\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgeHTM\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --single-argument %%1" /f > nul
reg add "HKCR\MSEdgeHTM\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --do-not-de-elevate --single-argument %%1" /f > nul
reg add "HKCR\MSEdgeMHT" /ve /t REG_SZ /d "Brave MHT Document" /f > nul
reg add "HKCR\MSEdgeMHT" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationName" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationDescription" /t REG_SZ /d "Access the Internet" /f > nul
reg add "HKCR\MSEdgeMHT\Application" /v "ApplicationCompany" /t REG_SZ /d "Brave Software Inc" /f > nul
reg add "HKCR\MSEdgeMHT\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgeMHT\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --single-argument %%1" /f > nul
reg add "HKCR\MSEdgeMHT\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --do-not-de-elevate --single-argument %%1" /f > nul
reg add "HKCR\MSEdgePDF" /ve /t REG_SZ /d "Brave PDF Document" /f > nul
reg add "HKCR\MSEdgePDF" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "AppUserModelId" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationIcon" /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationName" /t REG_SZ /d "Brave" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationDescription" /t REG_SZ /d "Access the Internet" /f > nul
reg add "HKCR\MSEdgePDF\Application" /v "ApplicationCompany" /t REG_SZ /d "Brave Software Inc" /f > nul
reg add "HKCR\MSEdgePDF\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe,0" /f > nul
reg add "HKCR\MSEdgePDF\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --single-argument %%1" /f > nul
reg add "HKCR\MSEdgePDF\shell\runas\command" /ve /t REG_SZ /d "\"C:\Program Files\BraveSoftware\Brave-Browser\Application\brave.exe\" --do-not-de-elevate --single-argument %%1" /f > nul
echo Should be completed.
pause && exit /b
:edgeF
:: Edge (F = fail)
echo LibreWolf or Brave was not found in the default path.
echo LibreWolf was not found in the default Scoop path either.
pause && exit /b

:existS
set /P c=This will disable SearchApp and StartMenuExperienceHost, are you sure you want to continue[Y/N]?
if /I "%c%" EQU "Y" goto continSS
if /I "%c%" EQU "N" exit

:continSS
:: Rename Start Menu
chdir /d %WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy

:restartStart
taskkill /F /IM StartMenuExperienceHost*
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old
:: Loop if it fails to rename the first time
if exist "%WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" goto restartStart
:: Rename Search
chdir /d %WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy

:restartSearch
taskkill /F /IM SearchApp*  >nul 2>nul
ren SearchApp.exe SearchApp.old
:: Loop if it fails to rename the first time
if exist "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe" goto restartSearch
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:enableStart
:: Rename Start Menu
chdir /d %WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
ren StartMenuExperienceHost.old StartMenuExperienceHost.exe
:: Rename Search
chdir /d %WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy
ren SearchApp.old SearchApp.exe
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:openshellInstall
curl -L --output %WinDir%\DuckModules\oshellI.exe https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.8/OpenShellSetup_4_4_8.exe
IF EXIST "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" goto existOS
IF EXIST "%WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy" goto existOS
goto rmSSOS

:existOS
set /P c=It appears Search and Start are installed, would you like to disable them also?[Y/N]?
if /I "%c%" EQU "Y" goto rmSSOS
if /I "%c%" EQU "N" goto skipRM

:rmSSOS
:: Rename Start Menu
chdir /d %WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy

:OSrestartStart
taskkill /F /IM StartMenuExperienceHost*
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old
:: Loop if it fails to rename the first time
if exist "%WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" goto OSrestartStart
:: Rename Search
chdir /d %WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy

:OSrestartSearch
taskkill /F /IM SearchApp*  >nul 2>nul
ren SearchApp.exe SearchApp.old
:: Loop if it fails to rename the first time
if exist "%WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe" goto OSrestartSearch
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Removed...>> %WinDir%\DuckModules\logs\userScript.log

:skipRM
:: Install silently
echo.
echo Openshell is installing...
"oshellI.exe" /qn ADDLOCAL=StartMenu
curl -L https://github.com/bonzibudd/Fluent-Metro/releases/download/v1.5/Fluent-Metro_1.5.zip -o skin.zip
7z -aoa -r e "skin.zip" -o"C:\Program Files\Open-Shell\Skins"
del /F /Q skin.zip >nul 2>nul
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Open-Shell Installed...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:uwp
IF EXIST "C:\Program Files\Open-Shell" goto uwpD
IF EXIST "C:\Program Files (x86)\StartIsBack" goto uwpD
echo It seems Open-Shell nor StartIsBack are installed. It is HIGHLY recommended to install one of these before running this due to the startmenu being removed.
pause&exit

:uwpD
echo This will remove all UWP packages that are currently installed. This will break multiple features that WILL NOT be supported while disabled.
echo A reminder of a few things this may break.
echo - Searching in file explorer
echo - Store
echo - Xbox
echo - Immersive Control Panel (Settings)
echo - Adobe XD
echo - Startmenu context menu
echo - Wi-Fi Menu
echo - Microsoft Accounts
echo - Microsoft Store
echo Please PROCEED WITH CAUTION, you are doing this at your own risk.
pause
:: Detect if user is using a Microsoft Account
powershell -NoProfile -Command "Get-LocalUser | Select-Object Name,PrincipalSource"|findstr /C:"MicrosoftAccount" >nul 2>&1 && set MSACCOUNT=YES || set MSACCOUNT=NO
if "%MSACCOUNT%"=="NO" ( sc config wlidsvc start=disabled ) ELSE ( echo "Microsoft Account detected, not disabling wlidsvc..." )
choice /c yn /m "Last warning, continue? [Y/N]" /n
sc stop TabletInputService
sc config TabletInputService start=disabled

:: Disable the option for Windows Store in the "Open With" dialog
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "1" /f
:: Block Access to Windows Store
reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "1" /f
sc config InstallService start=disabled
:: Insufficent permissions to disable
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
sc config mpssvc start=disabled
sc config AppXSvc start=disabled
sc config BFE start=disabled
sc config TokenBroker start=disabled
sc config LicenseManager start=disabled
sc config ClipSVC start=disabled

taskkill /F /IM StartMenuExperienceHost*  >nul 2>nul
ren %WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.old
taskkill /F /IM SearchApp*  >nul 2>nul
ren %WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy Microsoft.Windows.Search_cw5n1h2txyewy.old
ren %WinDir%\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy Microsoft.XboxGameCallableUI_cw5n1h2txyewy.old
ren %WinDir%\SystemApps\Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe.old

taskkill /F /IM RuntimeBroker*  >nul 2>nul
ren %WinDir%\System32\RuntimeBroker.exe RuntimeBroker.exe.old
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 0 /F
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% UWP Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

pause
:uwpE
sc config TabletInputService start=demand
:: Disable the option for Windows Store in the "Open With" dialog
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "0" /f
:: Block Access to Windows Store
reg add "HKLM\Software\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d "0" /f
sc config InstallService start=demand
:: Insufficent permissions to disable
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "3" /f
sc config mpssvc start=auto
sc config wlidsvc start=demand
sc config AppXSvc start=demand
sc config BFE start=auto
sc config TokenBroker start=demand
sc config LicenseManager start=demand
sc config ClipSVC start=demand
taskkill /F /IM StartMenuExperienceHost*  >nul 2>nul
ren %WinDir%\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.old Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
taskkill /F /IM SearchApp*  >nul 2>nul
ren %WinDir%\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.old Microsoft.Windows.Search_cw5n1h2txyewy
ren %WinDir%\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy.old Microsoft.XboxGameCallableUI_cw5n1h2txyewy
ren %WinDir%\SystemApps\Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe.old Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe
taskkill /F /IM RuntimeBroker*  >nul 2>nul
ren %WinDir%\System32\RuntimeBroker.exe.old RuntimeBroker.exe
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 0 /F
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% UWP Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:mitE
powershell -NoProfile set-ProcessMitigation -System -Enable DEP
powershell -NoProfile set-ProcessMitigation -System -Enable EmulateAtlThunks
powershell -NoProfile set-ProcessMitigation -System -Enable RequireInfo
powershell -NoProfile set-ProcessMitigation -System -Enable BottomUp
powershell -NoProfile set-ProcessMitigation -System -Enable HighEntropy
powershell -NoProfile set-ProcessMitigation -System -Enable StrictHandle
powershell -NoProfile set-ProcessMitigation -System -Enable CFG
powershell -NoProfile set-ProcessMitigation -System -Enable StrictCFG
powershell -NoProfile set-ProcessMitigation -System -Enable SuppressExports
powershell -NoProfile set-ProcessMitigation -System -Enable SEHOP
powershell -NoProfile set-ProcessMitigation -System -Enable AuditSEHOP
powershell -NoProfile set-ProcessMitigation -System -Enable SEHOPTelemetry
powershell -NoProfile set-ProcessMitigation -System -Enable ForceRelocateImages
goto finish

:startlayout
reg delete "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /f >nul 2>nul
%currentuser% reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /f >nul 2>nul
reg delete "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /f >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% StartLayout Policy Removed...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:sleepD
:: Disable Away Mode policy
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 0
:: Disable Idle States
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
powercfg /setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 0
:: Disable Hybrid Sleep
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
powercfg /setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Sleep States Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:sleepE
:: Enable Away Mode policy
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 25dfa149-5dd1-4736-b5ab-e8a37b5b8187 1
:: Enable Idle States
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 1
powercfg /setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 abfc2519-3608-4c2a-94ea-171b0ed546ab 1
:: Enable Hybrid Sleep
powercfg /setacvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 1
powercfg /setdcvalueindex 11111111-1111-1111-1111-111111111111 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 1
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Sleep States Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:idleD
echo THIS WILL CAUSE YOUR CPU USAGE TO *DISPLAY* AS 100%. ENABLE IDLE IF THIS IS AN ISSUE.
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Idle Disabled...>> %WinDir%\DuckModules\logs\userScript.log

goto finishNRB
:idleE
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Idle Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:xboxU
choice /c yn /m "This is currently not easily reversable, continue? [Y/N]" /n
echo Removing via PowerShell...
powershell -NoProfile -Command "Get-AppxPackage *Xbox* | Remove-AppxPackage" >nul 2>nul
echo Disabling Services...
sc config XblAuthManager start=disabled
sc config XblGameSave start=disabled
sc config XboxGipSvc start=disabled
sc config XboxNetApiSvc start=disabled
%svc% BcastDVRUserService 4
if %ERRORLEVEL%==0 echo %date% - %time% Xbox Related Apps and Services Removed...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:vcreR
echo Opening Visual C++ Runtimes installer...
echo Fixes most DLL errors.
vcredist.exe /ai
echo Installation done.
if %ERRORLEVEL%==0 echo %date% - %time% Visual C++ Runtimes installed...>> %WinDir%\DuckModules\logs\userScript.log
if %settweaks%==0 (goto finishNRB) else (exit /b)

:uacD
echo Disabling UAC breaks fullscreen on certain UWP applications, one of them being Minecraft Windows 10 Edition. It is also less secure to disable UAC.
set /P c="Do you want to continue? [Y/N]: "
if /I "%c%" EQU "Y" goto uacDconfirm
if /I "%c%" EQU "N" exit
exit

:uacDconfirm
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\Appinfo" /v "Start" /t REG_DWORD /d "4" /f
if %ERRORLEVEL%==0 echo %date% - %time% UAC Disabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish

:uacE
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg add "HKLM\System\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\Appinfo" /v "Start" /t REG_DWORD /d "3" /f
if %ERRORLEVEL%==0 echo %date% - %time% UAC Enabled...>> %WinDir%\DuckModules\logs\userScript.log
if %settweaks%==0 goto finish
exit /b

:firewallD
reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
if %ERRORLEVEL%==0 echo %date% - %time% Firewall Disabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish
:firewallE
reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
if %ERRORLEVEL%==0 echo %date% - %time% Firewall Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:aniE
reg delete "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /f >nul 2>nul
%currentuser% reg delete "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /f >nul 2>nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9e3e078012000000" /f
if %ERRORLEVEL%==0 echo %date% - %time% Animations Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:aniD
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f
if %ERRORLEVEL%==0 echo %date% - %time% Animations Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:workstationD
reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f
dism /Online /Disable-Feature /FeatureName:SmbDirect /norestart
if %ERRORLEVEL%==0 echo %date% - %time% Workstation Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:workstationE
reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "2" /f
dism /Online /Enable-Feature /FeatureName:SmbDirect /norestart
if %ERRORLEVEL%==0 echo %date% - %time% Workstation Enabled...>> %WinDir%\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish
:printE
set /P c=You may be vulnerable to Print Nightmare Exploits while printing is enabled. Would you like to add Group Policies to protect against them? [Y/N]
if /I "%c%" EQU "Y" goto nightmareGPO
if /I "%c%" EQU "N" goto printECont
goto nightmareGPO
:nightmareGPO
echo The spooler will not accept client connections nor allow users to share printers.
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers" /v "RegisterSpoolerRemoteRpcEndPoint" /t REG_DWORD /d "2" /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v "RestrictDriverInstallationToAdministrators" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v "Restricted" /t REG_DWORD /d "1" /f
:: Prevent Print Drivers over HTTP
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers" /v "DisableWebPnPDownload" /t REG_DWORD /d "1" /f
:: Disable Printing over HTTP
reg add "HKLM\Software\Policies\Microsoft\Windows NT\Printers" /v "DisableHTTPPrinting" /t REG_DWORD /d "1" /f
:printECont
echo Enable context menu...
Reg.exe delete "HKLM\Software\Classes\batfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\cmdfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\docxfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\fonfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\htmlfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\InternetShortcut\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\JSEFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\pfmfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\regfile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\rtffile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\ttffile\shell\print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\VBEFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\VBSFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
Reg.exe delete "HKLM\Software\Classes\WSFFile\Shell\Print" /v "ProgrammaticAccessOnly" /f
reg add "HKLM\System\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "2" /f
if %ERRORLEVEL%==0 echo %date% - %time% Printing Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:printD
echo Disable context menu...
Reg.exe add "HKLM\Software\Classes\batfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\cmdfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\docxfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\fonfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\htmlfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\InternetShortcut\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\JSEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\pfmfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\regfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\rtffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\ttffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\VBEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\VBSFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
Reg.exe add "HKLM\Software\Classes\WSFFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f
reg add "HKLM\System\CurrentControlSet\Services\Spooler" /v "Start" /t REG_DWORD /d "4" /f
if %ERRORLEVEL%==0 echo %date% - %time% Printing Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:telemetryIPs
sc query mpssvc | find "4  RUNNING" >nul 2>&1
if %errorlevel%==1 (
	echo You must have Windows Firewall enabled to use this script.
	if %settweaks%==0 pause
	exit /b
)
ping -n 1 example.com >nul 2>&1
if %errorlevel%==1 (
	echo Internet connectivity is required to use this script.
	if %settweaks%==0 pause
	exit /b
)
if %settweaks%==1 goto telemetryIPapply
echo This script downloads an IP list filled with telemetry IP addresses related to Microsoft services.
echo It then blocks those IP addresses using Windows Firewall.
echo]
echo 1) Apply rules
echo 2) Delete old rules (if they exist)
choice /c:12 /n /m "What do you want to do? [1, 2]
if %errorlevel%==1 set applyblockedips=true && set deleteblockedips=false
if %errorlevel%==2 set deleteblockedips=true && applyblockedips=false

:telemetryIPdelete
echo]
echo Delete old telemetry rules
echo --------------------------------------------------------
echo Inbound
netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Inbound" > nul
echo Outbound
netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Outbound" > nul
if %deleteblockedips%==true (goto finishNRB)

:telemetryIPapply
echo Delete old temporary files (if they exist)
del /f /q /s %tmp%\ip_blocklist_microsoft_telemetry.txt >nul 2>&1
del /f /q /s %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt >nul 2>&1
echo Download the list and make it a pure list of IP addresses
curl -s https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt -o %tmp%\ip_blocklist_microsoft_telemetry.txt
findstr "[1-999].[1-999].[1-999].[1-999]" %tmp%\ip_blocklist_microsoft_telemetry.txt > %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt
echo]
echo Block Microsoft related telemetry IP addresses
echo --------------------------------------------------------
powershell -NoProfile -NoLogo -Command "$iplist = Get-Content %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt; New-NetFirewallRule -DisplayName 'Block Telemetry (duckISO) - Inbound' -Direction Inbound -Protocol Any -Action Block -RemoteAddress ($iplist) | Out-Null"
powershell -NoProfile -NoLogo -Command "$iplist = Get-Content %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt; New-NetFirewallRule -DisplayName 'Block Telemetry (duckISO) - Outbound' -Direction Outbound -Protocol Any -Action Block -RemoteAddress ($iplist) | Out-Null"
if %settweaks%==1 (exit /b) else (goto finishNRB)

:dataQueueM
echo Mouse Data Queue Sizes
echo This may affect stability and input latency. And if low enough may cause mouse skipping/mouse stutters.
echo.
echo Windows Default: 100
echo duckISO Default: 30
echo Valid Value Range: 1-100
set /P c="Enter the size you want to set Mouse Data Queue Size to: "
:: Filter to numbers only
echo %c%|findstr /r "[^0-9]" > nul
if %ERRORLEVEL%==1 goto dataQueueMSet 
cls
echo Only values from 1-100 are allowed!
goto dataQueueM
:: Checks for invalid values
:dataQueueMSet
reg add "HKLM\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "%c%" /f
if %ERRORLEVEL%==0 echo %date% - %time% Mouse Data Queue Size set to %c%...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:dataQueueK
echo Keyboard Data Queue Sizes
echo This may affect stability and input latency. And if low enough may cause general keyboard issues like ghosting.
echo.
echo Windows Default: 100
echo duckISO Default: 30
echo Valid Value Range: 1-100
set /P c="Enter the size you want to set Keyboard Data Queue Size to: "
:: Filter to numbers only
echo %c%|findstr /r "[^0-9]" > nul
if %ERRORLEVEL%==1 goto dataQueueKSet
cls
echo Only values from 1-100 are allowed!
goto dataQueueK
:: Checks for invalid values
:dataQueueKSet
reg add "HKLM\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "%c%" /f
if %ERRORLEVEL%==0 echo %date% - %time% Keyboard Data Queue Size set to %c%...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:netWinDefault
netsh int ip reset
netsh winsock reset
:: Extremely awful way to do this
:: duck
:: woof
for /f "tokens=3* delims=: " %%i in ('pnputil /enum-devices /class Net /connected^| findstr "Device Description:"') do (
	devmanview /uninstall "%%i %%j"
)
pnputil /scan-devices
if %ERRORLEVEL%==0 echo %date% - %time% Network Setting Reset to Windows Default...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:netDuckDefault
echo]
echo %c_yellow%╭───────────────────────────────────────────────╮
echo │ Network tweaks...		                     │
echo ╰───────────────────────────────────────────────╯%c_reset%

echo Disabling Nagle's algorithm...
:: Helps with ping, reduces throughput
:: Note: does nothing to Minecraft
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do (
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f > nul
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f > nul
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f > nul
)
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosNonBestEffortLimit
echo 'NonBestEffortLimit' to 0 (QoS)
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f > nul
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosTimerResolution
echo 'TimerResolution' to 1 (QoS)
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f > nul
echo 'Do not use NLA' to 1 (required for DSCP policies)
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f > nul
:: reg add "HKLM\System\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f
echo Disable Multicast
reg add "HKLM\Software\Policies\Microsoft\Windows NT\DNSClient" /v "EnableMulticast" /t REG_DWORD /d "0" /f > nul

echo]
echo Configuring NIC settings...
echo Note: meant for the Intel I225-V controller
:: Configure NIC settings
:: Get NIC driver settings path by querying for DWORDs
:: If you see a way to optimise this segment, feel free to open a pull request
:: Made for Intel(R) Ethernet Controller I225-V 
:: https://github.com/djdallmann/GamingPCSetup/blob/master/CONTENT/DOCS/NETWORK/README.md#intel-network-adapter-settings=
for /f %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Class" /v "*WakeOnMagicPacket" /s ^| findstr  "HKEY"') do (
    :: Check if the value exists, to prevent errors and uneeded settings
    for /f %%i in ('reg query "%%a" /v "*InterruptModeration" ^| findstr "HKEY"') do (
        :: add the value
        :: if the value does not exist, it will silently error.
        reg add "%%i" /v "*InterruptModeration" /t REG_SZ /d "1" /f > nul
    )
    for /f %%i in ('reg query "%%a" /v "*EEE" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*EEE" /t REG_DWORD /d "0" /f > nul
    )
    for /f %%i in ('reg query "%%a" /v "*FlowControl" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*FlowControl" /t REG_DWORD /d "0" /f > nul
    )
	:: My added settings mostly from GamingPCSetup
    for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*TCPChecksumOffloadIPv4" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*TCPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*TCPChecksumOffloadIPv6" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*UDPChecksumOffloadIPv4" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*UDPChecksumOffloadIPv6" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*UDPChecksumOffloadIPv6" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*WakeOnPattern" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*WakeOnPattern" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*WakeOnMagicPacket" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*WakeOnMagicPacket" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "WakeOnMagicPacketFromS5" ^| findstr "HKEY"') do (
        reg add "%%i" /v "WakeOnMagicPacketFromS5" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*LsoV2IPv4" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*LsoV2IPv4" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*LsoV2IPv6" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*LsoV2IPv6" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*IPChecksumOffloadIPv4" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*IPChecksumOffloadIPv4" /t REG_SZ /d "3" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*SpeedDuplex" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*SpeedDuplex" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*PMARPOffload" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*PMARPOffload" /t REG_SZ /d "1" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*PMNSOffload" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*PMNSOffload" /t REG_SZ /d "1" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*HeaderDataSplit" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*HeaderDataSplit" /t REG_SZ /d "1" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*IdleRestriction" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*IdleRestriction" /t REG_SZ /d "0" /f > nul
    )
	for /f %%i in ('reg query "%%a" /v "*PriorityVLANTag" ^| findstr "HKEY"') do (
        reg add "%%i" /v "*PriorityVLANTag" /t REG_SZ /d "3" /f > nul
    )
) >nul 2>nul
echo]
echo NetSH tweaks...
netsh int tcp set heuristics disabled > nul
:: https://www.speedguide.net/articles/windows-8-10-server-2019-tcpip-tweaks-5077
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "0200" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Nsi\{eb004a03-9b1a-11d4-9123-0050047759bc}\0" /v "1700" /t REG_BINARY /d "0000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000ff000000000000000000000000000000000000000000ff000000000000000000000000000000" /f > nul
netsh int tcp set supplemental Internet congestionprovider=ctcp > nul
netsh int tcp set global timestamps=disabled > nul
netsh int tcp set global rsc=disabled > nul
netsh interface Teredo set state type=default > nul
netsh interface Teredo set state servername=default > nul
for /f "tokens=1" %%i in ('netsh int ip show interfaces ^| findstr [0-9]') do (
	netsh int ip set interface %%i routerdiscovery=disabled store=persistent > nul
)

echo]
echo Disabling network adapters...
:: IPv6, Client for Microsoft Networks, File and Printer Sharing, Link-Layer Topology Discovery Responder, Link-Layer Topology Discovery Mapper I/O Driver, Microsoft Network Adapter Multiplexor Protocol, Microsoft LLDP Protocol Driver
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_rspndr, ms_lltdio, ms_implat, ms_lldp" >nul 2>&1

echo]
echo Disable LMHOSTS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d "0" /f > nul

if %settweaks%==1 (exit /b)
if %ERRORLEVEL%==0 (echo %date% - %time% Network Optimized...>> %WinDir%\DuckModules\logs\userScript.log
) ELSE (echo %date% - %time% Failed to Optimize Network! >> %WinDir%\DuckModules\logs\userScript.log)
goto finish

:debugProfile
systeminfo > %WinDir%\DuckModules\logs\systemInfo.log
goto finish

:firewallTelemetry
:: Delete old temporary files
del /f /q /s %tmp%\ip_blocklist_microsoft_telemetry.txt >nul 2>&1
del /f /q /s %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt >nul 2>&1
del /f /q /s %tmp%\ip_blocklist_microsoft_telemetry_list.txt >nul 2>&1
:: Download the list
:: Major credit to WindowsSpyBlocker for the IP list! https://github.com/crazy-max/WindowsSpyBlocker
curl -s https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/firewall/spy.txt -o %tmp%\ip_blocklist_microsoft_telemetry.txt
:: Make a list of pure IP addresses
findstr "[1-999].[1-999].[1-999].[1-999]" %tmp%\ip_blocklist_microsoft_telemetry.txt > %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt
:: To check if there's old rules set
netsh advfirewall firewall show rule name=all | findstr /c:"Block Telemetry (duckISO) - " >nul 2>&1
if %errorlevel%==0 (
	echo]
	echo Delete old Microsoft telemetry related rules
	netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Inbound" > nul
	netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Outbound" > nul
)
echo]
echo Block Microsoft related telemetry IP addresses
powershell -NoProfile -NoLogo -Command "$iplist = Get-Content %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt; New-NetFirewallRule -DisplayName 'Block Telemetry (duckISO) - Inbound' -Direction Inbound -Protocol Any -Action Block -RemoteAddress ($iplist) | Out-Null"
powershell -NoProfile -NoLogo -Command "$iplist = Get-Content %tmp%\ip_blocklist_microsoft_telemetry_cleaned.txt; New-NetFirewallRule -DisplayName 'Block Telemetry (duckISO) - Outbound' -Direction Outbound -Protocol Any -Action Block -RemoteAddress ($iplist) | Out-Null"
if %postinstall%==0 (goto finishNRB) else (exit /b)

:delFirewallTelemetry
echo]
echo Delete Microsoft telemetry related rules
echo --------------------------------------------------------
netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Inbound" > nul
netsh advfirewall firewall delete rule name="Block Telemetry (duckISO) - Outbound" > nul
goto finishNRB

:vpnD
devmanview /disable "WAN Miniport (IKEv2)"
devmanview /disable "WAN Miniport (IP)"
devmanview /disable "WAN Miniport (IPv6)"
devmanview /disable "WAN Miniport (L2TP)"
devmanview /disable "WAN Miniport (Network Monitor)"
devmanview /disable "WAN Miniport (PPPOE)"
devmanview /disable "WAN Miniport (PPTP)"
devmanview /disable "WAN Miniport (SSTP)"
devmanview /disable "NDIS Virtual Network Adapter Enumerator"
devmanview /disable "Microsoft RRAS Root Enumerator"
reg add "HKLM\System\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "4" /f
if %ERRORLEVEL%==0 echo %date% - %time% VPN Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:vpnE
devmanview /enable "WAN Miniport (IKEv2)"
devmanview /enable "WAN Miniport (IP)"
devmanview /enable "WAN Miniport (IPv6)"
devmanview /enable "WAN Miniport (L2TP)"
devmanview /enable "WAN Miniport (Network Monitor)"
devmanview /enable "WAN Miniport (PPPOE)"
devmanview /enable "WAN Miniport (PPTP)"
devmanview /enable "WAN Miniport (SSTP)"
devmanview /enable "NDIS Virtual Network Adapter Enumerator"
devmanview /enable "Microsoft RRAS Root Enumerator"
reg add "HKLM\System\CurrentControlSet\Services\IKEEXT" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\WinHttpAutoProxySvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\RasMan" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\SstpSvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\iphlpsvc" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\NdisVirtualBus" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\Eaphost" /v "Start" /t REG_DWORD /d "3" /f
if %ERRORLEVEL%==0 echo %date% - %time% VPN Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:wmpD
dism /Online /Disable-Feature /FeatureName:WindowsMediaPlayer /norestart
goto finish
:ieD
dism /Online /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 /norestart
goto finish
:eventlogD
echo This may break some features:
echo - CapFrameX
echo - Network Menu/Icon
echo If you experience random issues, please enable EventLog again.
sc config EventLog start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Event Log disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:eventlogE
sc config EventLog start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Event Log enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish
:scheduleD
echo Disabling Task Scheduler will break some features:
echo - MSI Afterburner startup/Updates
echo - UWP Typing (e.g. Search Bar)
sc config Schedule start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Task Scheduler disabled...>> %WinDir%\DuckModules\logs\userScript.log
echo If you experience random issues, please enable Task Scheduler again.
goto finish
:scheduleE
sc config Schedule start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Task Scheduler enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:scoop
echo Installing scoop...
set /P c="Review Install script before executing? [Y/N]: "
if /I "%c%" EQU "Y" curl "https://raw.githubusercontent.com/lukesampson/scoop/master/bin/install.ps1" -o %WinDir%\DuckModules\install.ps1 && notepad %WinDir%\DuckModules\install.ps1
if /I "%c%" EQU "N" curl "https://raw.githubusercontent.com/lukesampson/scoop/master/bin/install.ps1" -o %WinDir%\DuckModules\install.ps1
powershell -NoProfile Set-ExecutionPolicy RemoteSigned -scope CurrentUser
powershell -NoProfile %WinDir%\DuckModules\install.ps1
echo Refreshing environment for Scoop...
call %WinDir%\DuckModules\refreshenv.cmd
echo.
echo Installing git...
:: Scoop isn't very nice with batch scripts, and will break the whole script if a warning or error shows..
cmd /c scoop install git -g
call %WinDir%\DuckModules\refreshenv.cmd
echo .
echo Adding extras bucket...
cmd /c scoop bucket add extras
goto finish

:browser
for /f "tokens=1 delims=;" %%i in ('%WinDir%\DuckModules\Apps\multichoice.exe "Browser" "Pick a browser" "Ungoogled-Chromium;Firefox;Brave;GoogleChrome"') do (
	set spacedelimited=%%i
	set spacedelimited=!spacedelimited:;= !
	cmd /c scoop install !spacedelimited! -g
)
::if "%filtered%" == "" echo You need to install a browser! You will need it later on. && pause && goto browser
:: must launch in separate process, scoop seems to exit the whole script if not
goto finish

:altSoftware
:: Findstr for 7zip-zstd, add versions bucket if errlvl 0
for /f "tokens=*" %%i in ('%WinDir%\DuckModules\Apps\multichoice.exe "Common Software" "Install Common Software" "discord;bleachbit;notepadplusplus;msiafterburner;rtss;thunderbird;foobar2000;irfanview;git;mpv;vlc;vscode;putty;ditto"') do (
    set spacedelimited=%%i
	set spacedelimited=!spacedelimited:;= !
	cmd /c scoop install !spacedelimited! -g
)
goto finish

:updateE
echo This will enable Windows Update. Tweaks might revert on an update.
echo Credit to AMIT for the initial .reg file to disable updates.
echo]
echo Waiting 2 seconds then press any key...
timeout /t 2 /nobreak > nul
pause
goto updateE2
:updateE2
echo]
:: reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetProxyBehaviorForUpdateDetection" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /f > nul
:: reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /f > nul
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /f > nul
:: reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /f > nul
:: reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /f > nul
:: Services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "2" /f > nul
:: End of services
:: Prevents drivers from installing with Windows Update
:: reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /f > nul
:: reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /f > nul
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "IsExpedited" /t REG_DWORD /d "0" /f > nul
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /f > nul
:: reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f > nul
:: reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f > nul
if %settweaks%==1 exit /b
echo]
echo Done, look for errors above.
choice /n /c:yn /m "Would you like to restart now? Needed to apply the changes. [Y/N]"
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to Windows Update" & exit /b
if %errorlevel%==2 exit /b

:updateD
echo This will disable Windows Update, making Windows more buggy and less secure.
echo However, tweaks will not revert and it is slightly more convienient.
echo Credit to AMIT for the initial .reg file.
echo]
echo Waiting 2 seconds then press any key...
timeout /t 2 /nobreak > nul
pause
echo]
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUServer" /t REG_SZ /d "0.0.0.0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "WUStatusServer" /t REG_SZ /d "0.0.0.0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "UpdateServiceUrlAlternate" /t REG_SZ /d "0.0.0.0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetProxyBehaviorForUpdateDetection" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "SetDisableUXWUAccess" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "DoNotConnectToWindowsUpdateInternetLocations" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "UseWUServer" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > nul
:: Services
reg add "HKLM\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\UsoSvc" /v "Start" /t REG_DWORD /d "4" /f > nul
:: End of sercvices
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "HideMCTLink" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "IsExpedited" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "RestartNotificationsAllowed2" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f > nul
echo]
echo Done, look for errors above.
choice /n /c:yn /m "Would you like to restart now? Needed to apply the changes. [Y/N]"
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to Windows Update" & exit /b
if %errorlevel%==2 exit /b

:insiderE
echo This will enable Windows Insider (dev) builds without a Microsoft account.
echo It will probably work without telemetry, but there is no guarentees.
echo YOU CAN NOT REVERT BACK WITHOUT REINSTALLING OR WAITING TILL A NEXT STABLE UPDATE!
echo]
echo What would you like to set? (in order of least stable to the most)
echo 1) Developer Windows Insider (not recommended)
echo 2) Beta Windows Insider
echo 3) Release Preview Insider (recommended)
choice /c:123 /n /m "What would you like to do? [1/2/3] "
if %errorlevel%==1 set BranchReadinessLevelValue=2
if %errorlevel%==2 set BranchReadinessLevelValue=4
if %errorlevel%==3 set BranchReadinessLevelValue=8
echo]
choice /c:yn /n /m "Are you sure? [Y/N] "
if %errorlevel%==1 (goto insiderE2)
if %errorlevel%==2 (
	echo]
	echo If you are not sure about using Windows Insider, then do not use it.
	echo You can have frequent crashes and other issues that aren't fun.
	echo I have experienced these with Valorant on developer Insider.
	echo Release preview is the most stable.
	echo]
	pause
	exit /b 1
)
:insiderE2
echo]
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /t REG_DWORD /d %BranchReadinessLevelValue% /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /t REG_DWORD /d 2 /f
echo]
echo Done, look for errors above.
choice /n /c:yn /m "Would you like to restart now? Needed to apply the changes [Y/N]"
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to insider builds" & exit /b
if %errorlevel%==2 exit /b

:insiderD
echo This will disable Windows Insider builds, making it so you only recieve stable updates.
echo Your insider build won't disappear, you will stay on it until there's a next stable release.
echo]
echo Waiting 2 seconds then press any key...
timeout /t 2 /nobreak > nul
pause
echo]
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "BranchReadinessLevel" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuilds" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ManagePreviewBuildsPolicyValue" /f
echo]
echo Done, look for errors above.
choice /n /c:yn /m "Would you like to restart now? Needed to apply the changes [Y/N]"
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to insider builds" & exit /b
if %errorlevel%==2 exit /b

:WUduckDefault
echo This will apply the default policies for duckISO.
echo Your policies will be cleared.
echo]
echo Waiting 2 seconds then press any key...
timeout /t 2 /nobreak > nul
pause
goto WUduckDefault2
:WUduckDefault2
echo]
echo Stopping services...
sc stop wuauserv > nul
sc stop WaaSMedicSvc > nul
sc stop UsoSvc > nul
echo]
set deferqualityupdates=false
set deferfeatureupdates=false
set blockfeatureupdates=false
choice /c:yn /n /m "Would you like to defer feature updates up until 365 days? [Y/N]"
if %errorlevel%==1 (set deferqualityupdates=true) else (
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /f
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /f 
) >nul 2>&1
choice /c:yn /n /m "Would you like to defer quality updates up until 4 days? [Y/N]"
if %errorlevel%==1 (set deferfeatureupdates=true) else (
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /f > nul
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /f > nul
) >nul 2>&1
choice /c:yn /n /m "Would you like to block feature updates? [Y/N]"
if %errorlevel%==1 (set blockfeatureupdates=true) else (
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /f > nul
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /f > nul
	reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /f > nul
) >nul 2>&1
reg delete "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /v "PreventDeviceMetadataFromNetwork" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer" /v "DisableCoInstallers" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ExcludeWUDriversInQualityUpdate" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "SetAutoRestartNotificationDisable" /t REG_DWORD /d "1" /f > nul
if %deferfeatureupdates%==true (
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdates" /t REG_DWORD /d "1" /f > nul
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferFeatureUpdatesPeriodInDays" /t REG_DWORD /d "365" /f > nul
)
if %deferqualityupdates%==true (
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdates" /t REG_DWORD /d "1" /f > nul
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "DeferQualityUpdatesPeriodInDays" /t REG_DWORD /d "4" /f > nul
)
if %blockfeatureupdates%==true (
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d "1" /f > nul
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /t REG_SZ /d "%os%" /f > nul
	reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "%releaseid%" /f > nul
)
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "17" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "EnableFeaturedSoftware" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "IncludeRecommendedUpdates" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AutoInstallMinorUpdates" /t REG_DWORD /d "0" /f > nul
reg add "HKU\S-1-5-20\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v "DownloadMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "OptInOOBE" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching" /v "DontSearchWindowsUpdate" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v "SystemSettingsDownloadMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v "DODownloadMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\DriverSearching" /v "SearchOrderConfig" /t REG_DWORD /d "0" /f > nul
echo]
echo Done, look for errors above.
echo %date% - %time% Default Windows Update policies applied >> %WinDir%\DuckModules\logs\userScript.log
if %settweaks%==1 exit /b
choice /n /c:yn /m "Would you like to restart now? Needed to apply the changes. [Y/N]"
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to Windows Update" & exit /b
if %errorlevel%==2 exit /b

:: Static IP
:staticIP
call :netcheck
set /P dns1="Set DNS Server (e.g. 1.1.1.1): "
for /f "tokens=4" %%i in ('netsh int show interface ^| find "Connected"') do set devicename=%%i
::for /f "tokens=2 delims=[]" %%i in ('ping -4 -n 1 %ComputerName%^| findstr [') do set LocalIP=%%i
for /f "tokens=3" %%i in ('netsh int ip show config name^="%devicename%" ^| findstr "IP Address:"') do set LocalIP=%%i
for /f "tokens=3" %%i in ('netsh int ip show config name^="%devicename%" ^| findstr "Default Gateway:"') do set DHCPGateway=%%i
for /f "tokens=2 delims=()" %%i in ('netsh int ip show config name^="Ethernet" ^| findstr "Subnet Prefix:"') do for /F "tokens=2" %%a in ("%%i") do set DHCPSubnetMask=%%a
netsh int ipv4 set address name="%devicename%" static %LocalIP% %DHCPSubnetMask% %DHCPGateway%
powershell -NoProfile -Command "Set-DnsClientServerAddress -InterfaceAlias "%devicename%" -ServerAddresses %dns1%"
echo %date% - %time% Static IP set! (%LocalIP%)(%DHCPGateway%)(%DHCPSubnetMask%) >> %WinDir%\DuckModules\logs\userScript.log
echo Private IP: %LocalIP%
echo Gateway: %DHCPGateway%
echo Subnet Mask: %DHCPSubnetMask%
echo If this information appears to be incorrect or is blank, please report it on Discord (preferred) or Github.
goto finish
::reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "Start" /t REG_DWORD /d "4" /f
::reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "4" /f
::reg add "HKLM\System\CurrentControlSet\Services\netprofm" /v "Start" /t REG_DWORD /d "4" /f

:displayScalingD
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /s /f Scaling ^| find /i "Configuration\"') do (
	reg add "%%i" /v "Scaling" /t REG_DWORD /d "1" /f
)
if %ERRORLEVEL%==0 echo %date% - %time% Display Scaling Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:DSCPauto
for /f "tokens=* delims=\" %%i in ('%WinDir%\DuckModules\Apps\filepicker.exe exe') do (
    if "%%i"=="cancelled by user" exit
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Application Name" /t REG_SZ /d "%%~ni%%~xi" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Version" /t REG_SZ /d "1.0" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Protocol" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local Port" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Local IP Prefix Length" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote Port" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Remote IP Prefix Length" /t REG_SZ /d "*" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "DSCP Value" /t REG_SZ /d "46" /f
    reg add "HKLM\Software\Policies\Microsoft\Windows\QoS\%%~ni%%~xi" /v "Throttle Rate" /t REG_SZ /d "-1" /f
)
goto finish

:NVPstate
:: Credits to Timecard
:: https://github.com/djdallmann/GamingPCSetup/tree/master/CONTENT/RESEARCH/WINDRIVERS#q-is-there-a-registry-setting-that-can-force-your-display-adapter-to-remain-at-its-highest-performance-state-pstate-p0
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo You do not have NVIDIA GPU drivers installed.
    pause
    exit /B
)
echo This will force P0 on your NVIDIA card AT ALL TIMES, it will always run at full power.
echo It is not recommended if you leave your computer on while idle, have bad cooling or use a laptop.
pause
for /F "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "NVIDIA"^| findstr "HK"') do (
    reg add "%%i" /v "DisableDynamicPstate" /t REG_DWORD /d "1" /f
)
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Dynamic P-States Disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:revertNVPState
for /F "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "NVIDIA"^| findstr "HK"') do (
    reg delete "%%i" /v "DisableDynamicPstate" /f
)
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Dynamic P-States Enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finish

:nvcontainerD
:: check if the service exists
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
	echo You may not have NVIDIA drivers installed.
    pause
    exit /b 1
)

echo Disabling the 'NVIDIA Display Container LS' service will stop the NVIDIA Control Panel from working.
echo It will most likely break other NVIDIA driver features as well.
echo These scripts are aimed at users that have a stripped driver, and people that barely touch the NVIDIA Control Panel.
echo]
echo You can enable the NVIDIA Control Panel and the service again by running the enable script.
echo Additionally, you can add a context menu to the desktop with another script in the Atlas folder.
echo]
echo Read README.txt for more info.
pause

sc config NVDisplay.ContainerLocalSystem start=disabled > nul
sc stop NVDisplay.ContainerLocalSystem > nul
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerE
:: check if the service exists
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
	echo You may not have NVIDIA drivers installed.
    pause
    exit /b 1
)

sc config NVDisplay.ContainerLocalSystem start=auto > nul
sc start NVDisplay.ContainerLocalSystem > nul
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerCME
:: cm = context menu
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
	echo You may not have NVIDIA drivers installed.
    pause
    exit /b 1
)
echo Explorer will be restarted to ensure that the context menu works.
pause

reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "Icon" /t REG_SZ /d "%WinDir%\DuckModules\NVIDIA.ico,0" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "MUIVerb" /t REG_SZ /d "NVIDIA Container" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "Position" /t REG_SZ /d "Bottom" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001" /v "MUIVerb" /t REG_SZ /d "Enable NVIDIA Display Container LS" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001\command" /ve /t REG_SZ /d "%WinDir%\DuckModules\nsudo.exe -U:T -P:E -UseCurrentConsole -Wait %WinDir%\DuckModules\duck-config.bat /nvcontainerE" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002" /v "MUIVerb" /t REG_SZ /d "Disable NVIDIA Display Container LS" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002\command" /ve /t REG_SZ /d "%WinDir%\DuckModules\nsudo.exe -U:T -P:E -UseCurrentConsole -Wait %WinDir%\DuckModules\duck-config.bat /nvcontainerD" /f
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
NSudo.exe -U:C explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS context menu enabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerCMD
:: cm = context menu
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
	echo You may not have NVIDIA drivers installed.
    pause
    exit /b 1
)
reg query "HKCR\DesktopBackground\shell\NVIDIAContainer" >nul 2>&1
if %errorlevel%==1 (
    echo The context menu does not exist, you can not continue.
    pause
    exit /b 1
)

echo Explorer will be restarted to ensure that the context menu is removed.
pause

reg delete "HKCR\DesktopBackground\Shell\NVIDIAContainer" /f > nul

:: delete icon exe
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
NSudo.exe -U:C explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS context menu disabled...>> %WinDir%\DuckModules\logs\userScript.log
goto finishNRB

:networksharingE
echo Enabling Workstation as a dependency...
call :workstationE "int"
sc config eventlog start=auto
echo %date% - %time% EventLog enabled as Network Sharing dependency...>> %WinDir%\DuckModules\logs\userscript.log
reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\netman" /v "Start" /t REG_DWORD /d "3" /f
echo %date% - %time% Network Sharing enabled...>> %WinDir%\DuckModules\logs\userscript.log
echo To complete, enable Network Sharing in control panel.
goto :finish

:defender
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
	echo You can not continue, run this as admin.
	pause
    exit 0
)
whoami /user | find /i "S-1-5-18" >nul 2>&1 
if %errorlevel%==0 (
    echo You are running this script as TrustedInstaller.
	echo You can not continue, run this as admin.
	pause
    exit 0
)
choice /c:yn /n /m "Have you disabled tamper protection and all other protection options in the Security app? [Y/N]"
if %errorlevel%==2 goto defenderfail
choice /c:yn /n /m "You sure? [Y/N]"
if %errorlevel%==1 goto defender2
if %errorlevel%==2 goto defenderfail

:defender2
setlocal DisableDelayedExpansion
echo Disable Early Launch Anti-Malware Protection - BCDEDIT
bcdedit /set disableelamdrivers Yes
echo Add exclusions
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "C:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "D:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "E:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "F:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "G:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "A:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "B:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "H:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "I:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "J:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "K:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "L:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "M:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "N:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "O:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "P:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "Q:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "R:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "S:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "T:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "U:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "V:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "W:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "X:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "Y:\\" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths" /v "Z:\\" /t REG_DWORD /d "0" /f > nul

echo Disable the Potentially Unwanted Application (PUA) feature
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'PUAProtection'; $value = '0'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -PUAProtection $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
:: For legacy versions: Windows 10 v1809 and Windows Server 2019
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpEnablePus" /t REG_DWORD /d "0" /f
:: For newer Windows versions
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "PUAProtection" /t REG_DWORD /d "0" /f

echo Disable file hash computation feature
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "EnableFileHashComputation" /t REG_DWORD /d "0" /f

echo Disable always running antimalware service
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d "1" /f

echo Disable auto-exclusions
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableAutoExclusions'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableAutoExclusions $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Exclusions" /v "DisableAutoExclusions" /t reg_DWORD /d "1" /f

echo Turn off block at first sight
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableBlockAtFirstSeen'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableBlockAtFirstSeen $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SpyNet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d "1" /f

echo Set maximum time possible for extended cloud check timeout
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpBafsExtendedTimeout" /t REG_DWORD /d 50 /f

echo Set lowest possible cloud protection level
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\MpEngine" /v "MpCloudBlockLevel" /t REG_DWORD /d 0 /f

echo Disable receiving notifications to disable security intelligence
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureDisableNotification" /t REG_DWORD /d 0 /f

echo Turn off Windows Defender SpyNet reporting
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'MAPSReporting'; $value = '0'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -MAPSReporting $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpynetReporting" /t REG_DWORD /d "0" /f

echo Do not send file samples for further analysis
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'SubmitSamplesConsent'; $value = '2'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -SubmitSamplesConsent $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t REG_DWORD /d "2" /f

echo Disable Malicious Software Reporting tool diagnostic data
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t REG_DWORD /d 1 /f

echo Disable uploading files for threat analysis in real-time
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "RealtimeSignatureDelivery" /t REG_DWORD /d 0 /f

echo Disable prevention of users and apps from accessing dangerous websites
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Network Protection" /v "EnableNetworkProtection" /t REG_DWORD /d "1" /f

echo Disable Controlled folder access
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\Controlled Folder Access" /v "EnableControlledFolderAccess" /t REG_DWORD /d "0" /f

echo Disable protocol recognition
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS" /v "DisableProtocolRecognition" /t REG_DWORD /d "1" /f

echo Disable definition retirement
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "DisableSignatureRetirement" /t REG_DWORD /d "1" /f

echo Limit detection events rate to minimum
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\NIS\Consumers\IPS" /v "ThrottleDetectionEventsRate" /t REG_DWORD /d "10000000" /f

echo Disable real-time monitoring
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableRealtimeMonitoring'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableRealtimeMonitoring $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d "1" /f

echo Disable Intrusion Prevention System (IPS)
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableIntrusionPreventionSystem'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableIntrusionPreventionSystem $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIntrusionPreventionSystem" /t REG_DWORD /d "1" /f

echo Disable Information Protection Control (IPC)
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableInformationProtectionControl" /t REG_DWORD /d "1" /f

echo Disable process scanning on real-time protection
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d "1" /f

echo Disable behavior monitoring
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableBehaviorMonitoring'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableBehaviorMonitoring $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d "1" /f

echo Disable sending raw write notifications to behavior monitoring
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRawWriteNotification" /t REG_DWORD /d "1" /f

echo Disable scanning for all downloaded files and attachments
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableIOAVProtection'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableIOAVProtection $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableIOAVProtection" /t REG_DWORD /d "1" /f

echo Disable scanning files bigger than 1 KB (minimum possible)
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "IOAVMaxSize" /t REG_DWORD /d "1" /f

echo Disable monitoring file and program activity
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d "1" /f

echo Disable bidirectional scanning of incoming and outgoing file and program activity
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'RealTimeScanDirection'; $value = '1'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -RealTimeScanDirection $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "RealTimeScanDirection" /t REG_DWORD /d "1" /f

echo Disable routine remediation
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d "1" /f

echo Disable running scheduled auto-remediation
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Remediation" /v "Scan_ScheduleDay" /t REG_DWORD /d "8" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'RemediationScheduleDay'; $value = '8'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -RemediationScheduleDay $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable remediation actions
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'UnknownThreatDefaultAction'; $value = '9'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -UnknownThreatDefaultAction $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats" /v "Threats_ThreatSeverityDefaultAction" /t "REG_DWORD" /d "1" /f
:: 1: Clean, 2: Quarantine, 3: Remove, 6: Allow, 8: Ask user, 9: No action, 10: Block, NULL: default (based on the update definition)
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "5" /t "REG_SZ" /d "9" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "4" /t "REG_SZ" /d "9" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "3" /t "REG_SZ" /d "9" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "2" /t "REG_SZ" /d "9" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Threats\ThreatSeverityDefaultAction" /v "1" /t "REG_SZ" /d "9" /f

echo Auto-purge items from Quarantine folder
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'QuarantinePurgeItemsAfterDelay'; $value = '1'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -QuarantinePurgeItemsAfterDelay $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Quarantine" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f

echo Disable checking for signatures before scan
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'CheckForSignaturesBeforeRunningScan'; $value = $False; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -CheckForSignaturesBeforeRunningScan $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "CheckForSignaturesBeforeRunningScan" /t REG_DWORD /d "0" /f

echo Disable creating system restore point on a daily basis
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableRestorePoint'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableRestorePoint $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRestorePoint" /t REG_DWORD /d "1" /f

echo Set minumum time for keeping files in scan history folder
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'ScanPurgeItemsAfterDelay'; $value = '1'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -ScanPurgeItemsAfterDelay $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "PurgeItemsAfterDelay" /t REG_DWORD /d "1" /f

echo Set maximum days before a catch-up scan is forced
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "MissedScheduledScanCountBeforeCatchup" /t REG_DWORD /d "20" /f

echo Disable catch-up full scans
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableCatchupFullScan'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableCatchupFullScan $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupFullScan" /t REG_DWORD /d "1" /f

echo Disable catch-up quick scans
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableCatchupQuickScan'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableCatchupQuickScan $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCatchupQuickScan" /t REG_DWORD /d "1" /f

echo Disable scan heuristics
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableHeuristics" /t REG_DWORD /d "1" /f

echo Disable scanning when not idle
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'ScanOnlyIfIdleEnabled'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -ScanOnlyIfIdleEnabled $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanOnlyIfIdle" /t REG_DWORD /d "1" /f

echo Disable scheduled On Demand anti malware scanner (MRT)
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t REG_DWORD /d 1 /f

echo Limit CPU usage during scans to minimum
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'ScanAvgCPULoadFactor'; $value = '1'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -ScanAvgCPULoadFactor $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "AvgCPULoadFactor" /t REG_DWORD /d "1" /f

echo Limit CPU usage during idle scans to minumum
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableCpuThrottleOnIdleScans'; $value = $False; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableCpuThrottleOnIdleScans $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableCpuThrottleOnIdleScans" /t REG_DWORD /d "0" /f

echo Disable e-mail scanning
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableEmailScanning'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableEmailScanning $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableEmailScanning" /t REG_DWORD /d "1" /f

echo Disable script scanning
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableScriptScanning'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableScriptScanning $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable reparse point scanning
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableReparsePointScanning" /t REG_DWORD /d "1" /f

echo Disable scanning on mapped network drives on full-scan
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningMappedNetworkDrivesForFullScan" /t REG_DWORD /d "1" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableScanningMappedNetworkDrivesForFullScan'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableScanningMappedNetworkDrivesForFullScan $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable scanning network files
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableScanningNetworkFiles" /t REG_DWORD /d "1" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableScanningNetworkFiles'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableScanningNetworkFiles $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable scanning packed executables
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisablePackedExeScanning" /t REG_DWORD /d "1" /f

echo Disable scanning removable drives
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableRemovableDriveScanning" /t REG_DWORD /d "1" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableRemovableDriveScanning'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableRemovableDriveScanning $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable scanning archive files
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "DisableArchiveScanning" /t REG_DWORD /d "1" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableArchiveScanning'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableArchiveScanning $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit depth for scanning archive files to minimum
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxDepth" /t REG_DWORD /d "0" /f

echo Limit file size for archive files to be scanned to minimum
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ArchiveMaxSize" /t REG_DWORD /d "1" /f

echo Disable scheduled scans
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScheduleDay" /t REG_DWORD /d "8" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'ScanScheduleDay'; $value = '8'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -ScanScheduleDay $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable randomizing scheduled task times
reg add "HKLM\Software\Policies\Microsoft\Windows Defender" /v "RandomizeScheduleTaskTimes" /t REG_DWORD /d "0" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'RandomizeScheduleTaskTimes'; $value = $False; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -RandomizeScheduleTaskTimes $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable scheduled full-scans
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "ScanParameters" /t REG_DWORD /d "1" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'ScanParameters'; $value = '1'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -ScanParameters $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit how many times quick scans run per day
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Scan" /v "QuickScanInterval" /t REG_DWORD /d "24" /f

echo Disable scanning after security intelligence (signature) update
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScanOnUpdate" /t REG_DWORD /d "1" /f

echo Limit Defender updates to those that complete gradual release cycle
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DisableGradualRelease'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DisableGradualRelease $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit Defender engine updates to those that complete gradual release cycle
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'EngineUpdatesChannel'; $value = 'Broad'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -EngineUpdatesChannel $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit Defender platform updates to those that complete gradual release cycle
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'PlatformUpdatesChannel'; $value = 'Broad'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -PlatformUpdatesChannel $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit Defender definition updates to those that complete gradual release cycle
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'DefinitionUpdatesChannel'; $value = 'Broad'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -DefinitionUpdatesChannel $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable forced security intelligence (signature) updates from Microsoft Update
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d 1 /f

echo Disable security intelligence (signature) updates when running on battery power
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableScheduledSignatureUpdateOnBattery" /t REG_DWORD /d 1 /f

echo Disable checking for the latest virus and spyware security intelligence (signature) on startup
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "UpdateOnStartUp" /t REG_DWORD /d 1 /f

echo Disable catch-up security intelligence (signature) updates
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateCatchupInterval" /t REG_DWORD /d "0" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'SignatureUpdateCatchupInterval'; $value = '0'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -SignatureUpdateCatchupInterval $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit spyware security intelligence (signature) updates
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ASSignatureDue" /t REG_DWORD /d 4294967295 /f

echo Limit virus security intelligence (signature) updates
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "AVSignatureDue" /t REG_DWORD /d 4294967295 /f

echo Disable security intelligence (signature) update on startup
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "DisableUpdateOnStartupWithoutEngine" /t REG_DWORD /d 1 /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'SignatureDisableUpdateOnStartupWithoutEngine'; $value = $True; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -SignatureDisableUpdateOnStartupWithoutEngine $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable automatically checking security intelligence (signature) updates
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "ScheduleDay" /t REG_DWORD /d "8" /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'SignatureScheduleDay'; $value = '8'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -SignatureScheduleDay $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Limit update checks for security intelligence (signature) updates
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "SignatureUpdateInterval" /t REG_DWORD /d 24 /f
PowerShell -ExecutionPolicy Unrestricted -Command "$propertyName = 'SignatureUpdateInterval'; $value = '24'; if((Get-MpPreference -ErrorAction Ignore).$propertyName -eq $value) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is already `"^""$value`"^"" as desired."^""; exit 0; }; $command = Get-Command 'Set-MpPreference' -ErrorAction Ignore; if (!$command) {; Write-Warning 'Skipping. Command not found: "^""Set-MpPreference"^"".'; exit 0; }; if(!$command.Parameters.Keys.Contains($propertyName)) {; Write-Host "^""Skipping. `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; }; try {; Invoke-Expression "^""$($command.Name) -Force -$propertyName `$value -ErrorAction Stop"^""; Set-MpPreference -Force -SignatureUpdateInterval $value -ErrorAction Stop; Write-Host "^""Successfully set `"^""$propertyName`"^"" to `"^""$value`"^""."^""; exit 0; } catch {; if ( $_.FullyQualifiedErrorId -like '*0x800106ba*') {; Write-Warning "^""Cannot $($command.Name): Defender service (WinDefend) is not running. Try to enable it (revert) and re-run this?"^""; exit 0; } elseif (($_ | Out-String) -like '*Cannot convert*') {; Write-Host "^""Skipping. Argument `"^""$value`"^"" for property `"^""$propertyName`"^"" is not supported for `"^""$($command.Name)`"^""."^""; exit 0; } else {; Write-Error "^""Failed to set using $($command.Name): $_"^""; exit 1; }; }"

echo Disable definition updates through both WSUS and the Microsoft Malware Protection Center
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateHttpLocation" /t REG_DWORD /d "0" /f

echo Disable definition updates through both WSUS and Windows Update
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Signature Updates" /v "CheckAlternateDownloadLocation" /t REG_DWORD /d "0" /f

echo Disable Windows Defender logging
reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderApiLogger" /v "Start" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\DefenderAuditLogger" /v "Start" /t REG_DWORD /d "0" /f

echo Disable ETW Provider of Windows Defender (Windows Event Logs)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/Operational" /v "Enabled" /t Reg_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WINEVT\Channels\Microsoft-Windows-Windows Defender/WHC" /v "Enabled" /t Reg_DWORD /d 0 /f

echo Do not send Watson events
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" /v "DisableGenericRePorts" /t REG_DWORD /d 1 /f

echo Send minimum Windows software trace preprocessor (WPP Software Tracing) levels
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "WppTracingLevel" /t REG_DWORD /d 1 /f

echo Disable auditing events in Microsoft Defender Application Guard
reg add "HKLM\SOFTWARE\Policies\Microsoft\AppHVSI" /v "AuditApplicationGuard" /t REG_DWORD /d 0 /f

echo Hide Windows Defender Security Center icon
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Systray" /v "HideSystray" /t REG_DWORD /d "1" /f

echo Remove "Scan with Windows Defender" option from context menu
reg delete "HKLM\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" /va /f 2>nul
reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /v "InprocServer32" /f 2>nul
reg delete "HKCR\*\shellex\ContextMenuHandlers" /v "EPP" /f 2>nul
reg delete "HKCR\Directory\shellex\ContextMenuHandlers" /v "EPP" /f 2>nul
reg delete "HKCR\Drive\shellex\ContextMenuHandlers" /v "EPP" /f 2>nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /t REG_SZ /f > nul

echo Remove Windows Defender Security Center from taskbar
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f 2>nul

echo Enable headless UI mode
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Restrict threat history to administrators
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "DisablePrivacyMode" /t REG_DWORD /d "1" /f

echo Hide the "Virus and threat protection" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the "Ransomware data recovery" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection" /v "HideRansomwareRecovery" /t REG_DWORD /d "1" /f

echo Hide the "Family options" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the "Device performance and health" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the "Account protection" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the "App and browser protection" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the "Firewall and network protection" area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Firewall and network protection" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Hide the Device security area
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d "1" /f

echo Disable the Clear TPM button
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableClearTpmButton" /t REG_DWORD /d "1" /f

echo Disable the Secure boot area button
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideSecureBoot" /t REG_DWORD /d "1" /f

echo Hide the Security processor (TPM) troubleshooter page
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "HideTPMTroubleshooting" /t REG_DWORD /d "1" /f

echo Hide the TPM Firmware Update recommendation
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "DisableTpmFirmwareUpdateWarning" /t REG_DWORD /d "1" /f

echo Disable Windows Action Center security and maintenance notifications
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t REG_DWORD /d "0" /f

echo Disable all Windows Defender Antivirus notifications
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows Defender\UX Configuration" /v "Notification_Suppress" /t REG_DWORD /d "1" /f

echo Suppress reboot notifications
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\UX Configuration" /v "SuppressRebootNotification" /t REG_DWORD /d "1" /f

echo Hide all notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableNotifications" /t REG_DWORD /d "1" /f

echo Hide non-critical notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows Defender Security Center\Notifications" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\Reporting" /v "DisableEnhancedNotifications" /t REG_DWORD /d "1" /f

echo Disable Windows Defender ExploitGuard task
schtasks /Change /TN "Microsoft\Windows\ExploitGuard\ExploitGuard MDM policy Refresh" /Disable 2>nul

echo Disable Windows Defender Cache Maintenance task
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance" /Disable 2>nul

echo Disable Windows Defender Cleanup task
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Cleanup" /Disable 2>nul

echo Disable Windows Defender Scheduled Scan task
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan" /Disable 2>nul

echo Disable Windows Defender Verification task
schtasks /Change /TN "Microsoft\Windows\Windows Defender\Windows Defender Verification" /Disable 2>nul

echo Disable SmartScreen for apps and files
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableSmartScreen" /t REG_DWORD /d "0" /f

echo Disable SmartScreen in file explorer
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f

echo Disable SmartScreen preventing users from running applications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "ShellSmartScreenLevel" /t REG_SZ /d "Warn" /f

echo Prevent Chromium Edge SmartScreen from blocking potentially unwanted apps
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f

echo Disable SmartScreen in Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "PreventOverride" /t REG_DWORD /d "0" /f
:: For Microsoft Edge version 77 or later
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0" /f

echo Disable SmartScreen in Internet Explorer
reg add "HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "2301" /t REG_DWORD /d "1" /f

echo Turn off SmartScreen App Install Control feature
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControl" /t REG_SZ /d "Anywhere" /f
reg add "HKLM\Software\Policies\Microsoft\Windows Defender\SmartScreen" /v "ConfigureAppInstallControlEnabled" /t "REG_DWORD" /d "0" /f

echo Turn off SmartScreen to check web content (URLs) that apps use
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t REG_DWORD /d "0" /f

echo Disable driver blocklist
reg add "HKLM\System\CurrentControlSet\Control\CI\Config" /v "VulnerableDriverBlocklistEnable" /t REG_DWORD /d "0" /f

echo Disable Microsoft Defender Antivirus
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f

echo Disable Microsoft Defender Antivirus Network Inspection System Driver service
:: PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'net stop "^""WdNisDrv"^"" /yes >nul & sc config "^""WdNisDrv"^"" start=disabled'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"
sc stop WdNisDrv >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WdNisDrv" /v "Start" /t REG_DWORD /d "4" /f > nul
if exist "%SystemRoot%\System32\drivers\WdNisDrv.sys" (
    takeown /f "%SystemRoot%\System32\drivers\WdNisDrv.sys"
    icacls "%SystemRoot%\System32\drivers\WdNisDrv.sys" /grant administrators:F
    move "%SystemRoot%\System32\drivers\WdNisDrv.sys" "%SystemRoot%\System32\drivers\WdNisDrv.sys.OLD" && (
        echo Moved "%SystemRoot%\System32\drivers\WdNisDrv.sys" to "%SystemRoot%\System32\drivers\WdNisDrv.sys.OLD"
    ) || (
        echo Could not move %SystemRoot%\System32\drivers\WdNisDrv.sys 1>&2
    )
) else (
    echo No action required: %SystemRoot%\System32\drivers\WdNisDrv.sys is not found.
)

echo Disable Microsoft Defender Antivirus Mini-Filter Driver service
:: PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'sc stop "^""WdFilter"^"" >nul & sc config "^""WdFilter"^"" start=disabled'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"
sc stop WdFilter >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WdFilter" /v "Start" /t REG_DWORD /d "4" /f > nul
if exist "%SystemRoot%\System32\drivers\WdFilter.sys" (
    takeown /f "%SystemRoot%\System32\drivers\WdFilter.sys"
    icacls "%SystemRoot%\System32\drivers\WdFilter.sys" /grant administrators:F
    move "%SystemRoot%\System32\drivers\WdFilter.sys" "%SystemRoot%\System32\drivers\WdFilter.sys.OLD" && (
        echo Moved "%SystemRoot%\System32\drivers\WdFilter.sys" to "%SystemRoot%\System32\drivers\WdFilter.sys.OLD"
    ) || (
        echo Could not move %SystemRoot%\System32\drivers\WdFilter.sys 1>&2
    )
) else (
    echo No action required: %SystemRoot%\System32\drivers\WdFilter.sys is not found.
)

echo Disable Microsoft Defender Antivirus Boot Driver service
:: PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'sc stop "^""WdBoot"^"" >nul & sc config "^""WdBoot"^"" start=disabled'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"
sc stop WdBoot >nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WdBoot" /v "Start" /t REG_DWORD /d "4" /f > nul
if exist "%SystemRoot%\System32\drivers\WdBoot.sys" (
    takeown /f "%SystemRoot%\System32\drivers\WdBoot.sys"
    icacls "%SystemRoot%\System32\drivers\WdBoot.sys" /grant administrators:F
    move "%SystemRoot%\System32\drivers\WdBoot.sys" "%SystemRoot%\System32\drivers\WdBoot.sys.OLD" && (
        echo Moved "%SystemRoot%\System32\drivers\WdBoot.sys" to "%SystemRoot%\System32\drivers\WdBoot.sys.OLD"
    ) || (
        echo Could not move %SystemRoot%\System32\drivers\WdBoot.sys 1>&2
    )
) else (
    echo No action required: %SystemRoot%\System32\drivers\WdBoot.sys is not found.
)

echo Disable Windows Defender Antivirus service
:: PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'sc stop "^""WinDefend"^"" >nul & sc config "^""WinDefend"^"" start=disabled'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"
sc stop WinDefend > nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WinDefend" /v "Start" /t REG_DWORD /d "4" /f > nul

echo Disable Microsoft Defender Antivirus Network Inspection service
:: PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'sc stop "^""WdNisSvc"^"" >nul & sc config "^""WdNisSvc"^"" start=disabled'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"
sc stop WdNisSvc > nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\WdNisSvc" /v "Start" /t REG_DWORD /d "4" /f > nul

echo Disable Windows Defender Security Center Service
sc stop SecurityHealthService > nul 2>&1
reg add "HKLM\System\CurrentControlSet\Services\SecurityHealthService" /v "Start" /t REG_DWORD /d "4" /f > nul
if exist "%WinDir%\system32\SecurityHealthService.exe" (
    takeown /f "%WinDir%\system32\SecurityHealthService.exe"
    icacls "%WinDir%\system32\SecurityHealthService.exe" /grant administrators:F
    move "%WinDir%\system32\SecurityHealthService.exe" "%WinDir%\system32\SecurityHealthService.exe.OLD" && (
        echo Moved "%WinDir%\system32\SecurityHealthService.exe" to "%WinDir%\system32\SecurityHealthService.exe.OLD"
    ) || (
        echo Could not move %WinDir%\system32\SecurityHealthService.exe 1>&2
    )
) else (
    echo No action required: %WinDir%\system32\SecurityHealthService.exe is not found.
)

echo Disable Windows Defender Advanced Threat Protection Service service
PowerShell -ExecutionPolicy Unrestricted -Command "$serviceQuery = 'Sense'; <# -- 1. Skip if service does not exist #>; $service = Get-Service -Name $serviceQuery -ErrorAction SilentlyContinue; if(!$service) {; Write-Host "^""Service query `"^""$serviceQuery`"^"" did not yield any results, no need to disable it."^""; Exit 0; }; $serviceName = $service.Name; Write-Host "^""Disabling service: `"^""$serviceName`"^""."^""; <# -- 2. Stop if running #>; if ($service.Status -eq [System.ServiceProcess.ServiceControllerStatus]::Running) {; Write-Host "^""`"^""$serviceName`"^"" is running, trying to stop it."^""; try {; Stop-Service -Name "^""$serviceName"^"" -Force -ErrorAction Stop; Write-Host "^""Stopped `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Warning "^""Could not stop `"^""$serviceName`"^"", it will be stopped after reboot: $_"^""; }; } else {; Write-Host "^""`"^""$serviceName`"^"" is not running, no need to stop."^""; }; <# -- 3. Skip if service info is not found in registry #>; $registryKey = "^""HKLM:\SYSTEM\CurrentControlSet\Services\$serviceName"^""; if(!(Test-Path $registryKey)) {; Write-Host "^""`"^""$registryKey`"^"" is not found in registry, cannot enable it."^""; Exit 0; }; <# -- 4. Skip if already disabled #>; if( $(Get-ItemProperty -Path "^""$registryKey"^"").Start -eq 4) {; Write-Host "^""`"^""$serviceName`"^"" is already disabled from start, no further action is needed."^""; Exit 0; }; <# -- 5. Disable service #>; try {; Set-ItemProperty $registryKey -Name Start -Value 4 -Force -ErrorAction Stop; Write-Host "^""Disabled `"^""$serviceName`"^"" successfully."^""; } catch {; Write-Error "^""Could not disable `"^""$serviceName`"^"": $_"^""; }"
if exist "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe" (
    takeown /f "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe"
    icacls "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe" /grant administrators:F
    move "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe" "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe.OLD" && (
        echo Moved "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe" to "%ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe.OLD"
    ) || (
        echo Could not move %ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe 1>&2
    )
) else (
    echo No action required: %ProgramFiles%\Windows Defender Advanced Threat Protection\MsSense.exe is not found.
)

:: Disable other services/drivers
reg add "HKLM\SYSTEM\ControlSet001\Services\mssecflt" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\SgrmAgent" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\SgrmBroker" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\wscsvc" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\webthreatdefsvc" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\webthreatdefusersvc" /v "Start" /t REG_DWORD /d "4" /f > nul

if %settweaks%==1 exit /b 0
echo]
echo Done, look for errors above.
echo Your computer is going to restart if you press any key - needed to apply the changes.
echo Press any key to continue in 2 seconds...
timeout /t 2 /nobreak > nul
pause
if %errorlevel%==1 shutdown /r /f /t 10 /c "Required reboot to apply changes to Windows Defender" & exit /b
if %errorlevel%==2 exit /b

:defenderfail
echo]
echo You NEED to disable tamper protection to disable Defender. Disabling tamper protection also means that you aknowledge the security risks with disabling Defender.
echo It is also recommended to disable all of the other protections.
echo If you are in the post install script, then tamper protection should already be disabled, but you should still check.
pause
start "" "windowsdefender:"ghb    
echo]
choice /c:ec /n /m "Would you like to (e)xit/continue with the post install and skip Defender or (c)ontinue? [E/C]"
if %errorlevel%==1 rem quack
if %errorlevel%==2 goto defender
if %settweaks%==1 (goto tweaksfinish) else (exit /b 1)

:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Batch functions										 ::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:setSvc
:: %svc% (service name) (0-4)
if "%1"=="" (echo You need to run this with a service to disable. && exit /b 1)
if "%2"=="" (echo You need to run this with an argument ^(1-4^) to configure the service's startup. && exit /b 1)
if %2 LSS 0 (echo Invalid configuration. && exit /b 1)
if %2 GTR 4 (echo Invalid configuration. && exit /b 1)
reg query "HKLM\System\CurrentControlSet\Services\%1" >nul 2>&1 || (echo The specified service/driver ^(%1^) is not found. && exit /b 1)
reg add "HKLM\System\CurrentControlSet\Services\%1" /v "Start" /t REG_DWORD /d "%2" /f > nul
exit /b 0

:setSvcPS
:: Modifies services
:: Example: call :service UserDataSvc_* 4
:: Not really used
for /f "tokens=*" %%F in ('powershell.exe -NoProfile "Get-Service -Name %1 | Select -ExpandProperty Name"') DO (
	reg add "HKLM\System\CurrentControlSet\Services\%%F" /v "Start" /t REG_DWORD /d "%2" /f
)
exit /b

:firewallBlockExe
:: Usage: %fireBlockExe% "[NAME]" "[EXE]"
:: Example: %fireBlockExe% "Calculator" "%WinDir%\System32\calc.exe"
:: Have both in quotes.
netsh advfirewall firewall delete rule name="Block %~1" protocol=any dir=in >nul 2>&1
netsh advfirewall firewall delete rule name="Block %~1" protocol=any dir=out >nul 2>&1
netsh advfirewall firewall add rule name="Block %~1" program=%2 protocol=any dir=in enable=yes action=block profile=any > nul
netsh advfirewall firewall add rule name="Block %~1" program=%2 protocol=any dir=out enable=yes action=block profile=any > nul
exit /b

:delCapability
if [%~1]==[] (echo No arguments specified! & exit /b 1)
if exist "C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp" del /f /q "C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp" > nul
for /f "tokens=1 delims=| " %%a in ('DISM.exe /Online /Get-Capabilities /Format:Table ^| find "Installed" ^| find "%~1"') do (echo %%a >> C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp)
if not exist "C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp" echo The specified capability was not found to be installed. & exit /b 1
for /f "tokens=*" %%a in ('type "C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp"') do (
	DISM /Online /Remove-Capability /CapabilityName:%%a /NoRestart /Quiet
	if not %errorlevel%==3010 echo Failed to remove the capability "%~1"!
)
del /f /q "C:\Windows\Temp\DISM_Get_Capabilities_duckISO.tmp" >nul 2>&1

:delPackage
if [%~1]==[] (echo No arguments specified! & exit /b 1)
if exist "C:\Windows\Temp\DDISM_Get_Packages_duckISO.tmp" del /f /q "C:\Windows\Temp\DISM_Get_Packages_duckISO.tmp" > nul
for /f "tokens=1 delims=| " %%a in ('DISM.exe /Online /Get-Packages /Format:Table ^| find "Installed" ^| find "%~1"') do (echo %%a >> C:\Windows\Temp\DISM_Get_Packages_duckISO.tmp)
if not exist "C:\Windows\Temp\DISM_Get_Packages_duckISO.tmp" echo The specified package was not found to be installed. & exit /b 1
for /f "tokens=*" %%a in ('type "C:\Windows\Temp\DISM_Get_Packages_duckISO.tmp"') do (
	DISM /Online /Remove-Package /PackageName:%%a /NoRestart /Quiet
	if not %errorlevel%==3010 echo Failed to remove the package "%~1"!
)
del /f /q "C:\Windows\Temp\DISM_Get_Packages_duckISO.tmp" >nul 2>&1

:disableFeature
if [%~1]==[] (echo No arguments specified! & exit /b 1)
if exist "C:\Windows\Temp\DISM_Get_Features_duckISO.tmp" del /f /q "C:\Windows\Temp\DISM_Get_Features_duckISO.tmp" > nul
for /f "tokens=1 delims=| " %%a in ('DISM.exe /Online /Get-Features /Format:Table ^| find "Enable" ^| find "%~1"') do (echo %%a >> C:\Windows\Temp\DISM_Get_Features_duckISO.tmp)
if not exist "C:\Windows\Temp\DISM_Get_Features_duckISO.tmp" echo The specified feature was found to already be disabled. & exit /b 1
for /f "tokens=*" %%a in ('type "C:\Windows\Temp\DISM_Get_Features_duckISO.tmp"') do (
	DISM /Online /Disable-Feature /FeatureName:%%a /NoRestart /Quiet
	if not %errorlevel%==3010 echo Failed to disable the feature "%~1"!
)
del /f /q "C:\Windows\Temp\DISM_Get_Features_duckISO.tmp" >nul 2>&1


:removeCapability
:: %delCapabilty% /debug (capability name)
:: %delPackage% /debug (package name, FOD)
:: %disableFeature% /debug (feature name)

:: Example: %delCapabilty% XPS.Viewer
:: If there are multiple results for one input, then it will only remove the first one in the list
:: You should be as specific as possible
:: Credit to Mathieu#4291 for fixing up my messy and broken code

for %%A in (_errorlevel fullname debug feature package) do (
    if defined %%A (
        set %%A=
    )
)

set commandget=/Get-Capabilities
set commandremove=/Remove-Capability
set commandname=/CapabilityName
set capability=true
set find=Installed

:removeCapability1
if not "%~1"=="" (
	if "%~1"=="/debug" (
		set debug=true
	)
	if "%~1"=="/feature" (
		set capability=false
		set feature=true
		set commandget=/Get-Features
		set commandremove=/Disable-Feature
  		set commandname=/FeatureName
		set find=Enabled
	)
	if "%~1"=="/package" (
		set capability=false
		set package=true
		set commandget=/Get-Packages
		set commandremove=/Remove-Package
		set commandname=/PackageName
	)
	shift
	goto removeCapability1
)

if %debug%==true (echo Input: %*)
for %%A in (_errorlevel fullname) do (
    if defined %%A (
        set %%A=
    )
)
for /f %%A in ('2^>nul DISM.exe /Online %commandget% /Format:Table ^| find ^"%find%^" ^| find ^"%1^" ^& call echo %%^^errorlevel%%') do (
    if defined _errorlevel (
        set "fullname=!_errorlevel!"
    )
    set "_errorlevel=%%A"
)
:: Should output the error level
if %debug%==true echo Errorlevel: %_errorlevel%
if not %_errorlevel%==0 (
    if %fullname%==true (echo Capabilities matching %1 were not found or there was an error listing installed capabilities && exit /b 1)
	if %feature%==true (echo Features matching %1 were not found or there was an error listing installed features && exit /b 1)
	if %package%==true (echo Packages matching %1 were not found or there was an error listing installed packages && exit /b 1)
)
echo Removing or disabling %fullname%
>nul 2>&1 DISM /Online %commandremove% %commandname%:%fullname% || (
    if !errorlevel!==1 (
        if %capability%==true (echo Error removing the %fullname% capability && exit /b 1)
		if %feature%==true (echo Error disabling the %fullname% feature && exit /b 1)
		if %package%==true (echo Error removing the %fullname% package && exit /b 1)
    )
)
exit /b

:invalidInput
:: invalidinput <label>
if "%c%"=="" echo Empty Input! Please enter Y or N. & goto %~1
if "%c%" NEQ "Y" if "%c%" NEQ "N" echo Invalid Input! Please enter Y or N. & goto %~1
exit /b

:netcheck
:: Checks for internet connectivity
ping -n 1 -4 example.com | find "time=" >nul 2>nul ||(
    echo Network is not connected! Please connect to a network before continuing.
	pause
	goto netcheck
) >nul 2>nul
exit /b

:FDel
:: fdel <location>
:: With NSudo, shouldnt need things like icacls/takeown
if exist "%~1" del /F /Q "%~1"
exit /b

:permFAIL
echo Permission grants failed. Please try again by launching the script through the respected scripts, which will give it the correct permissions.
pause
exit /b
:finish
echo Finished, please reboot for changes to apply.
pause
exit /b
:finishNRB
echo Finished, changes have been applied.
pause
exit /b
