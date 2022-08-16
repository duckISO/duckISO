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
set currentuser=C:\Windows\DuckModules\Apps\nsudo.exe -U:E -P:E -Wait
set system=C:\Windows\DuckModules\Apps\nsudo.exe -U:T -P:E -Wait

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
:: Hardening
if /i "%~1"=="/harden"         goto harden
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
:: Set post install variable
set postinstall=1
echo Creating logs directory for troubleshooting...
mkdir C:\Windows\DuckModules\logs

SETLOCAL DisableDelayedExpansion

echo]
echo Setting DuckModules in PATH...
setx path "%path%;C:\Windows\DuckModules;" -m  >nul
echo Refresh environment variables...
:: To ensure that the PATH variable is updated so that I can set the apps PATH
call C:\Windows\DuckModules\refreshenv.cmd
setx path "%path%;C:\Windows\DuckModules\Apps;" -m  >nul 2>nul
:: Refresh environment variables once more
call C:\Windows\DuckModules\refreshenv.cmd

SETLOCAL EnableDelayedExpansion

:: Breaks setting keyboard language
:: Rundll32.exe advapi32.dll,ProcessIdleTasks
echo Allow everyone to do anything to the DuckModules folder...
echo Allows for easier script editing
icacls C:\Windows\DuckModules /inheritance:r /grant Everyone:F /t > nul

echo Create success.txt to detect if the script has succeeded or not later on...
break>C:\Users\Public\success.txt
echo false > C:\Users\Public\success.txt

:tweaks-POST
:: set %os% variable to Windows 10 or Windows 11
call :setVer
set settweaks=1
echo]
:: Install VCRedist AIO package - fixes errors with missing DLLs
call :vcreR

echo]
echo Sync time and set to pool.ntp.org...
:: Set UTC to prevent issues with dual booting
reg add "HKLM\System\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /d 1 /t REG_DWORD /f > nul
:: Change NTP server from the default Windows server to pool.ntp.org
sc config W32Time start=demand >nul 2>nul
sc start W32Time >nul 2>nul
w32tm /config /syncfromflags:manual /manualpeerlist:"0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org" > nul
sc queryex "w32time"|Find "STATE"|Find /v "RUNNING"||(
    net stop w32time
    net start w32time
) >nul 2>nul
:: Resync time to pool.ntp.org
w32tm /config /update > nul
w32tm /resync > nul
sc stop W32Time > nul
sc config W32Time start=disabled > nul

echo]
echo Optimising NTFS parameters...
echo]
:: https://notes.ponderworthy.com/fsutil-tweaks-for-ntfs-performance-and-reliability
echo Disable last access info on directories - performance and privacy
fsutil behavior set disableLastAccess 1 > nul
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security/
echo Disable 8dot3 (short names) - performance and security
fsutil behavior set disable8dot3 1 > nul
:: Causes issues with DISM as an example
:: echo Disable NTFS compression - performance
:: fsutil behavior set disablecompression 1 > nul
echo Increase the RAM cache devoted to NTFS - performance
fsutil behavior set memoryusage 2 > nul
echo Disable filesystem mitigations - performance
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f > nul

echo]
echo Fix language packs...
:: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKLM\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable tasks...
echo Some tasks may not exist, that doesn't matter too much though
echo]
:: All of the tasks disabled here will eventually be researched into
echo Disabling \Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem
schtasks /Change /Disable /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" >nul
echo Disabling \Microsoft\Windows\Windows Error Reporting\QueueReporting
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul
echo Disabling \Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate
schtasks /Change /Disable /TN "\Microsoft\Windows\ErrorDetails\EnableErrorDetailsUpdate" >nul
echo Disabling \Microsoft\Windows\DiskFootprint\Diagnostics
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\Diagnostics" >nul
echo Disabling \Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul
echo Disabling "Disable apps to improve performance" reminder (\Microsoft\Windows\Application Experience\StartupAppTask)
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\StartupAppTask" >nul
echo Disabling \Microsoft\Windows\Autochk\Proxy
schtasks /Change /Disable /TN "\Microsoft\Windows\Autochk\Proxy" >nul
echo Disabling \Microsoft\Windows\Application Experience\PcaPatchDbTask
schtasks /Change /Disable /TN "\Microsoft\Windows\Application Experience\PcaPatchDbTask" >nul
echo Disabling \Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask
schtasks /Change /Disable /TN "\Microsoft\Windows\BrokerInfrastructure\BgTaskRegistrationMaintenanceTask" >nul
echo Disabling \Microsoft\Windows\CloudExperienceHost\CreateObjectTask
schtasks /Change /Disable /TN "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask" >nul
echo Disabling \Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" >nul
echo Disabling \Microsoft\Windows\Defrag\ScheduledDefrag
schtasks /Change /Disable /TN "\Microsoft\Windows\Defrag\ScheduledDefrag" >nul
echo Disabling \Microsoft\Windows\DiskFootprint\StorageSense
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskFootprint\StorageSense" >nul
echo Disabling \Microsoft\Windows\Registry\RegIdleBackup
schtasks /Change /Disable /TN "\Microsoft\Windows\Registry\RegIdleBackup" >nul
echo Disabling \Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange
schtasks /Change /Disable /TN "\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange" >nul
echo Disabling \Microsoft\Windows\Shell\IndexerAutomaticMaintenance
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\IndexerAutomaticMaintenance" >nul
echo Disabling \Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork" >nul
echo Disabling \Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon
schtasks /Change /Disable /TN "\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon" >nul
echo Disabling \Microsoft\Windows\StateRepository\MaintenanceTasks
schtasks /Change /Disable /TN "\Microsoft\Windows\StateRepository\MaintenanceTasks" >nul
echo Disabling \Microsoft\Windows\UPnP\UPnPHostConfig
schtasks /Change /Disable /TN "\Microsoft\Windows\UPnP\UPnPHostConfig" >nul
echo Disabling \Microsoft\Windows\RetailDemo\CleanupOfflineContent
schtasks /Change /Disable /TN "\Microsoft\Windows\RetailDemo\CleanupOfflineContent" >nul
echo Disabling \Microsoft\Windows\Shell\FamilySafetyMonitor
schtasks /Change /Disable /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" >nul
echo Disabling \Microsoft\Windows\InstallService\SmartRetry
schtasks /Change /Disable /TN "\Microsoft\Windows\InstallService\SmartRetry" >nul
echo Disabling \Microsoft\Windows\International\Synchronize Language Settings
schtasks /Change /Disable /TN "\Microsoft\Windows\International\Synchronize Language Settings" >nul
echo Disabling \Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents" >nul
echo Disabling \Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic
schtasks /Change /Disable /TN "\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic" >nul
echo Disabling \Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia
schtasks /Change /Disable /TN "\Microsoft\Windows\Multimedia\Microsoft\Windows\Multimedia" >nul
echo Disabling \Microsoft\Windows\Printing\EduPrintProv
schtasks /Change /Disable /TN "\Microsoft\Windows\Printing\EduPrintProv" >nul
echo Disabling \Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask
schtasks /Change /Disable /TN "\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask" >nul
echo Disabling \Microsoft\Windows\Ras\MobilityManager
schtasks /Change /Disable /TN "\Microsoft\Windows\Ras\MobilityManager" >nul
echo Disabling \Microsoft\Windows\PushToInstall\LoginCheck
schtasks /Change /Disable /TN "\Microsoft\Windows\PushToInstall\LoginCheck" >nul
echo Disabling \Microsoft\Windows\Time Synchronization\SynchronizeTime
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\SynchronizeTime" >nul
echo Disabling \Microsoft\Windows\Time Synchronization\ForceSynchronizeTime
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime" >nul
echo Disabling \Microsoft\Windows\Time Zone\SynchronizeTimeZone
schtasks /Change /Disable /TN "\Microsoft\Windows\Time Zone\SynchronizeTimeZone" >nul
echo Disabling \Microsoft\Windows\UpdateOrchestrator\Schedule Scan
schtasks /Change /Disable /TN "\Microsoft\Windows\UpdateOrchestrator\Schedule Scan" >nul
echo Disabling \Microsoft\Windows\WaaSMedic\PerformRemediation
schtasks /Change /Disable /TN "\Microsoft\Windows\WaaSMedic\PerformRemediation" >nul
echo Disabling \Microsoft\Windows\DiskCleanup\SilentCleanup
schtasks /Change /Disable /TN "\Microsoft\Windows\DiskCleanup\SilentCleanup" >nul
echo Disabling \Microsoft\Windows\Diagnosis\Scheduled
schtasks /Change /Disable /TN "\Microsoft\Windows\Diagnosis\Scheduled" >nul
echo Disabling \Microsoft\Windows\Wininet\CacheTask
schtasks /Change /Disable /TN "\Microsoft\Windows\Wininet\CacheTask" >nul
echo Disabling \Microsoft\Windows\Device Setup\Metadata Refresh
schtasks /Change /Disable /TN "\Microsoft\Windows\Device Setup\Metadata Refresh" >nul
echo Disabling \Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser
schtasks /Change /Disable /TN "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser" >nul
echo Disable Customer Experience Improvement Program
echo Disabling Customer Experience Improvement Program (\Microsoft\Windows\Customer Experience Improvement Program\Consolidator)
schtasks /Change /Disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul
echo Disabling Customer Experience Improvement Program (\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask)
schtasks /Change /Disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" >nul
echo Disabling Customer Experience Improvement Program (\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip)
schtasks /Change /Disable /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" >nul
echo Disabling Customer Experience Improvement Program (\Microsoft\Windows\Application Experience\ProgramDataUpdater)
schtasks /Change /Disable /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul
echo Disabling devicecensus.exe (telemetry) task (\Microsoft\Windows\Device Information\Device)
schtasks /Change /Disable /TN "Microsoft\Windows\Device Information\Device" >nul
echo Disabling Microsoft\Windows\Application Experience\ProgramDataUpdater
schtasks /Change /Disable /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" >nul
echo Disabling Application Impact Telemetry Agent task (\Microsoft\Windows\Application Experience\AitAgent)
schtasks /Change /Disable /TN "Microsoft\Windows\Application Experience\AitAgent" >nul 2>nul
echo Disabling Maps (\Microsoft\Windows\Maps\MapsUpdateTask)
schtasks /Change /Disable /TN "\Microsoft\Windows\Maps\MapsUpdateTask" >nul
echo Disabling Maps (\Microsoft\Windows\Maps\MapsToastTask)
schtasks /Change /Disable /TN "\Microsoft\Windows\Maps\MapsToastTask" >nul
echo Disabling Maps (\Microsoft\Windows\HelloFace\FODCleanupTask)
schtasks /Change /Disable /TN "\Microsoft\Windows\HelloFace\FODCleanupTask" >nul

echo]
echo MSI mode
echo]
echo Enable MSI mode for USB controllers...
:: second command for each device deletes device priorty, setting it to undefined
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul

echo Enable MSI mode on GPU, could be reset by installing a GPU driver...
:: Probably will be reset by installing GPU driver
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_VideoController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul

echo Enable MSI mode for network adapters...
:: undefined priority on some VMs may break connection
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
:: If e.g. vmware is used, skip setting to undefined.
wmic computersystem get manufacturer /format:value| findstr /i /C:VMWare&&goto vmGO-POST
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul
goto noVM-POST

:vmGO-POST
:: Set to Normal Priority
for /f %%i in ('wmic path Win32_NetworkAdapter get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /t REG_DWORD /d "2"  /f

:noVM-POST
echo]
echo Enable MSI mode on SATA controllers...
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_IDEController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul

:tweaks1-POST
echo]
echo Disable power saving
echo -------------------------------

echo Disable power savings on drives...
:: tokens arg breaks path to just \Device instead of \Device Parameters
for /f "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Enum" /s /f "StorPort"^| findstr "StorPort"') do reg add "%%i" /v "EnableIdlePowerManagement" /t REG_DWORD /d "0" /f > nul

echo Disable power saving on devices...
:: Disable Power Saving
:: Now lists PnP devices, instead of the previously used 'reg query'
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "0" /f
	reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "0" /f
) > nul
powershell -NoProfile -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $False; $p.psbase.put()}}}" >nul 2>nul

echo]
echo Power plan
echo -------------------------------
echo]

echo Import the powerplan...
powercfg -import "C:\Windows\DuckModules\Other\duckISO.pow" 11111111-1111-1111-1111-111111111111
echo Set current power plan to duckISO...
powercfg /s 11111111-1111-1111-1111-111111111111

echo Unhide power plan attributes...
:: Credits to: Eugene Muzychenko
for /f "tokens=1-9* delims=\ " %%A in ('reg query HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings /s /f attributes /e') do (
  if /i "%%A" == "HKEY_LOCAL_MACHINE" (
    set Ident=
    if not "%%G" == "" (
      set Err=
      set Group=%%G
      set Setting=%%H
      if "!Group:~35,1!" == "" set Err=group
      if not "!Group:~36,1!" == "" set Err=group
      if not "!Setting!" == "" (
        if "!Setting:~35,1!" == "" set Err=setting
        if not "!Setting:~36,1!" == "" set Err=setting
        Set Ident=!Group!:!Setting!
      ) else (
        Set Ident=!Group!
      )
      if not "!Err!" == "" (
        echo ***** Error in !Err! GUID: !Ident"
      )
    )
  ) else if "%%A" == "Attributes" (
    if "!Ident!" == "" (
      echo ***** No group/setting GUIDs before Attributes value
    )
    set /a Attr = %%C
    set /a Hidden = !Attr! ^& 1
    if !Hidden! equ 1 (
      echo Unhiding !Ident!
      powercfg -attributes !Ident::= ! -attrib_hide
    )
  )
) > nul

echo]
echo Set SvcSplitThreshold...
:: Credits: Revision
:: WARNING: Makes Windows less stable (if one service crashes, the whole svchost does as well), but reduces memory usage and makes Task Manager look more organised
:: Should not be an issue if there's no issues with services crashing
for /f "tokens=2 delims==" %%i in ('wmic os get TotalVisibleMemorySize /format:value') do set mem=%%i
set /a ram=%mem% + 1024000
reg add "HKLM\System\CurrentControlSet\Control" /v "SvcHostSplitThresholdInKB" /t REG_DWORD /d "%ram%" /f > nul

echo]
echo Disabling GameBarPresenceWriter...
reg add "HKLM\SOFTWARE\Microsoft\WindowsRuntime\ActivatableClassId\Windows.Gaming.GameBar.PresenceServer.Internal.PresenceWriter" /v "ActivationType" /t REG_DWORD /d "0" /f > nul
echo]
echo Disabling sync center...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetCache" /v "Enabled" /t REG_DWORD /d "0" /f > nul

:: Network tweaks
call :netDuckDefault

:tweaks2-POST
echo]
echo QoL
echo -------------------------------
if %postinstall%==1 (
	echo Fix duplicate Windows Server Update Client IDs ^(SusClientID^)
	sc stop wuauserv >nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientIdValidation" /f > nul
	reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientId" /t REG_SZ /d "00000000-0000-0000-0000-000000000000" /f > nul
)

echo]
echo Make some apps request UAC...
:: Make certain applications in the DuckModules folder request UAC
:: Although some of these applications may already request UAC, setting this compatibility flag ensures they are ran as administrator
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\duckISO\src\DuckModules\Apps\serviwin.exe" /t REG_SZ /d "~ RUNASADMIN" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\duckISO\src\DuckModules\Apps\DevManView.exe" /t REG_SZ /d "~ RUNASADMIN" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /v "C:\Windows\duckISO\src\DuckModules\Apps\nsudo.exe" /t REG_SZ /d "~ RUNASADMIN" /f > nul

:: disable hibernation
echo]
echo Disabling hibernation...
powercfg -h off > nul

echo]
echo Search Settings
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f > nul

:: Fix explorer whitebar bug
echo]
echo Fix explorer white-bar bug...
%currentuser% cmd /c "start C:\Windows\explorer.exe"
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
echo Waiting 3 seconds...
timeout /t 3 /nobreak > nul
%currentuser% cmd /c "start C:\Windows\explorer.exe"

echo]
echo Disable search indexing (use Everything by voidtools instead)
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "0" /f > nul

echo]
echo Disabling devices...
devmanview /disable "System Speaker"
devmanview /disable "System Timer"
devmanview /disable "UMBus Root Bus Enumerator"
:: May break games e.g GTA
:: devmanview /disable "Microsoft System Management BIOS Driver"
:: https://media.discordapp.net/attachments/835904146413453333/931696968336551986/unknown.png
:: devmanview /disable "Programmable Interrupt Controller"
devmanview /disable "High Precision Event Timer"
devmanview /disable "PCI Encryption/Decryption Controller"
devmanview /disable "AMD PSP"
devmanview /disable "Intel SMBus"
devmanview /disable "Intel Management Engine"
devmanview /disable "PCI Memory Controller"
devmanview /disable "PCI standard RAM Controller"
devmanview /disable "Composite Bus Enumerator"
devmanview /disable "Microsoft Kernel Debug Network Adapter"
devmanview /disable "SM Bus Controller"
devmanview /disable "NDIS Virtual Network Adapter Enumerator"
:: Breaks ISO mounts
:: devmanview /disable "Microsoft Virtual Drive Enumerator"
devmanview /disable "Numeric Data Processor"
devmanview /disable "Microsoft RRAS Root Enumerator"
echo]
echo Disabling WAN miniports...
devmanview /disable "WAN Miniport (IKEv2)"
devmanview /disable "WAN Miniport (IP)"
devmanview /disable "WAN Miniport (IPv6)"
devmanview /disable "WAN Miniport (L2TP)"
devmanview /disable "WAN Miniport (Network Monitor)"
devmanview /disable "WAN Miniport (PPPOE)"
devmanview /disable "WAN Miniport (PPTP)"
devmanview /disable "WAN Miniport (SSTP)"

:: Enable Hardware Accelerated Scheduling
:: Could increase latency?
:: https://docs.google.com/spreadsheets/d/1ZWQFycOWdODkUOuYZCxm5lTp08V2m7gjZQSCjywAsl8/edit#gid=227870975
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f

goto services_and_drivers_backup1-POST

:services_and_drivers_backup1-POST
echo]
echo Services and drivers backup
echo ------------------------------------
:: Backup default or current Windows Services and Drivers
:: Replace / with - in %date% - file name limiation
set newdate=%date:/=-%
:: Replace : with . in %time% - file name limiation
set newtime=%time::=.%

echo]
echo Backing up default Windows services or current services...
:: Could output a 'The syntax of the command is incorrect' error
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
echo Backing up default Windows drivers or current drivers...
:: Could output a 'The syntax of the command is incorrect' error
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

:: Remove dependencies
reg add "HKLM\System\CurrentControlSet\Services\Dhcp" /v "DependOnService" /t REG_MULTI_SZ /d "NSI\0Afd" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\Dnscache" /v "DependOnService" /t REG_MULTI_SZ /d "nsi" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\rdyboost" /v "DependOnService" /t REG_MULTI_SZ /d "" /f > nul

reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "UpperFilters" /t REG_MULTI_SZ /d "volsnap" /f > nul


:services_and_drivers_backup2-POST
:: Backup duckISO Services and Drivers
if %postinstall%==0 goto tweaks3-POST

echo]
echo Backing up duckISO services...
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
echo Backing up duckISO drivers...
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
echo BSOD QoL
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "CrashDumpEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\CrashControl" /v "DisplayParameters" /t REG_DWORD /d "1" /f > nul

:: GPO for Startmenu (tiles)
:: reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "C:\Windows\layout.xml" /f
:: reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d "1" /f
:: reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "1" /f
:: %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Group Policy Objects\{2F5183E9-4A32-40DD-9639-F9FAF80C79F4}Machine\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t REG_EXPAND_SZ /d "C:\Windows\layout.xml" /f

echo]
echo Enable dark mode, disable transparency
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "SystemUsesLightTheme" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "AppsUseLightTheme" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v "EnableTransparency" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Speech Model Updates
reg add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f > nul

echo]
echo Pause Maps Updates/Downloads - not needed
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f > nul

echo]
echo Delete annoying send to items
for /F "tokens=3 delims==\" %%a in ('wmic computersystem get username /value ^| find "="') do set "user=%%a"
del /f /s /q "C:\Users\%user%\AppData\Roaming\Microsoft\Windows\SendTo\Bluetooth File Transfer.LNK" > nul
del /f /s /q "C:\Users\%user%\AppData\Roaming\Microsoft\Windows\SendTo\Compressed (zipped) Folder.ZFSendToTarget" > nul
del /f /s /q "C:\Users\%user%\AppData\Roaming\Microsoft\Windows\SendTo\Desktop (create shortcut).DeskLink" > nul
del /f /s /q "C:\Users\%user%\AppData\Roaming\Microsoft\Windows\SendTo\Documents.mydocs" > nul
del /f /s /q "C:\Users\%user%\AppData\Roaming\Microsoft\Windows\SendTo\Mail Recipient.MAPIMail" > nul

echo]
echo Enable full classic context menus
%currentuser% reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

echo]
echo Disable CEIP
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Windows Media Player DRM Online Access
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable Web in Search
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Data Queue Sizes
:: set to 30
reg add "HKLM\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "30" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "30" /f > nul

echo]
echo Wallpaper
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f > nul
if %postinstall%==1 (
	%currentuser% reg add "HKCU\Control Panel\desktop" /v "Wallpaper" /t REG_SZ /d "" /f
	%currentuser% reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\DuckModules\Other\Wallpaper.png" /f 
	%currentuser% RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 
) > nul

echo]
echo Explorer
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoLowDiskSpaceChecks" /t REG_DWORD /d "1" /f > nul
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
echo Prevent downloading a list of providers for wizards
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWebServices" /t REG_DWORD /d 1 /f > nul

:: Broken on Win 11 insider (27/06/22)
:: echo Old Alt Tab
:: %currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f

echo]
echo Quick Assist capability
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'App.Support.QuickAssist*' | Remove-WindowsCapability -Online" > nul

echo]
echo Steps Recorder capability
PowerShell -ExecutionPolicy Unrestricted -Command "Get-WindowsCapability -Online -Name 'App.StepsRecorder*' | Remove-WindowsCapability -Online" > nul

echo]
echo OneDrive (probably is already stripped, just in case)
echo Might error out a bit on removing leftovers and other parts, ignore the errors
echo]
:: Kill OneDrive process
taskkill /f /im OneDrive.exe > nul
:: Uninstall OneDrive
if %PROCESSOR_ARCHITECTURE%==x86 (
    %SystemRoot%\System32\OneDriveSetup.exe /uninstall 2>nul
) else (
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall 2>nul
)
echo Remove OneDrive leftovers
rd "%UserProfile%\OneDrive" /q /s > nul
rd "%LocalAppData%\Microsoft\OneDrive" /q /s > nul
rd "%ProgramData%\Microsoft OneDrive" /q /s > nul
rd "%SystemDrive%\OneDriveTemp" /q /s > nul
echo Delete OneDrive shortcuts
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Microsoft OneDrive.lnk" /s /f /q > nul
del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" /s /f /q > nul
del "%USERPROFILE%\Links\OneDrive.lnk" /s /f /q > nul
echo Disable usage of OneDrive
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSyncNGSC" /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /t REG_DWORD /v "DisableFileSync" /d 1 /f > nul
reg add "HKLM\Software\Microsoft\OneDrive" /v "PreventNetworkTrafficPreUserSignIn" /t REG_DWORD /d "1" /f > nul
echo Prevent automatic OneDrive install for current user
%currentuser% reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f > nul
echo Prevent automatic OneDrive install for new users
reg load "HKU\Default" "%SystemDrive%\Users\Default\NTUSER.DAT"  > nul
reg delete "HKU\Default\software\Microsoft\Windows\CurrentVersion\Run" /v "OneDriveSetup" /f > nul
reg unload "HKU\Default" > nul
echo Remove OneDrive from explorer menu
reg delete "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul
reg delete "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f > nul
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /d "0" /t REG_DWORD /f > nul
reg add "HKCR\Wow6432Node\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /d "0" /t REG_DWORD /f > nul
echo Delete all OneDrive related Services
for /f "tokens=1 delims=," %%x in ('schtasks /query /fo csv ^| find "OneDrive"') do schtasks /Delete /TN %%x /F > nul
echo Delete OneDrive path from registry
%currentuser% reg delete "HKCU\Environment" /v "OneDrive" /f > nul

echo]
echo Remove Meet Now icon from taskbar
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d 1 /f > nul

echo]
echo Application Compatability Configuration
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable Mouse Acceleration
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseSensitivity" /t REG_SZ /d "10" /f > nul
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseSpeed" /t REG_SZ /d "0" /f > nul
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold1" /t REG_SZ /d "0" /f > nul
%currentuser% reg add "HKCU\Control Panel\Mouse" /v "MouseThreshold2" /t REG_SZ /d "0" /f > nul

echo]
echo Disable Annoying Keyboard Features
:: Disabling stick keys, mouse keys, filter keys and toggle keys normally seems to fail from my testing
%currentuser% reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t REG_DWORD /d "506" /f > nul
%currentuser% reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t REG_DWORD /d "122" /f > nul
%currentuser% reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t REG_DWORD /d "58" /f > nul
%currentuser% reg add "HKCU\Control Panel\Accessibility\MouseKeys" /v "Flags" /t REG_DWORD /d "58" /f > nul
:: Language bar shortcut
%currentuser% reg add "HKCU\Keyboard Layout\Toggle" /v "Layout Hotkey" /t REG_SZ /d "3" /f > nul
%currentuser% reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /t REG_DWORD /d "3" /f > nul
%currentuser% reg add "HKCU\Keyboard Layout\Toggle" /v "Hotkey" /t REG_DWORD /d "3" /f > nul

:: Disable Connection Checking (pings Microsoft Servers)
:: May cause internet icon to show it is disconnected
:: It's just a ping... lol
:: reg add "HKLM\System\CurrentControlSet\Services\NlaSvc\Parameters\Internet" /v "EnableActiveProbing" /t REG_DWORD /d "0" /f

echo]
echo Restrict Windows' access to internet resources
:: Enables various other GPOs that limit access on specific windows services
reg add "HKLM\Software\Policies\Microsoft\InternetManagement" /v "RestrictCommunication" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable text/ink handwriting telemetry
reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\HandwritingErrorReports" /v "PreventHandwritingErrorReports" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d "0" /f > nul

echo]
echo Do not allow Windows Ink Workspace
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v "AllowWindowsInkWorkspace" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Windows Error Reporting
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t "REG_DWORD" /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Data Collection
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowDeviceNameInTelemetry" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "DoNotShowFeedbackNotifications" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitEnhancedDiagnosticDataWindowsAnalytics" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /d 0 /t REG_DWORD /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "PeriodInNanoSeconds" /t REG_DWORD /d "0" /f

echo]
echo Disable devicecensus.exe (telemetry) process
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\'DeviceCensus.exe'" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f > nul

echo]
echo Disable CompatTelRunner.exe (Microsoft Compatibility Appraiser) process
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\'CompatTelRunner.exe'" /v "Debugger" /t REG_SZ /d "%windir%\System32\taskkill.exe" /f > nul

echo]
echo Disable sending site information (shows "Your browser is managed")
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d 0 /f > nul

echo]
echo Disable Edge usage and crash-related data reporting (shows "Your browser is managed")
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d 0 /f > nul

echo]
echo Do not send Windows Media Player statistics
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d 0 /f > nul

echo]
echo Disable metadata retrieval
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventCDDVDMetadataRetrieval" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventMusicFileMetadataRetrieval" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventRadioPresetsRetrieval" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /f > nul

echo]
echo Disable NET Core CLI telemetry
setx DOTNET_CLI_TELEMETRY_OPTOUT 1 > nul

echo]
echo Disable online tips
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "AllowOnlineTips" /t REG_DWORD /d 0 /f > nul

echo]
echo Disable lock screen app notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "DisableLockScreenAppNotifications" /t REG_DWORD /d 1 /f > nul

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

echo]
echo Advertising Info
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Sleep Study
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable OOBE after Windows Updates
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "PrivacyConsentStatus" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v "DisablePrivacyExperience" /t REG_DWORD /d "1" /f > nul

:: Opt-out of sending KMS client activation data to Microsoft automatically. Enabling this setting prevents this computer from sending data to Microsoft regarding its activation state.
:: reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f

echo]
echo Disable Feedback
%currentuser% reg add "HKCU\Software\Microsoft\Siuf\Rules" /v "NumberOfSIUFInPeriod" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Settings Sync
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSyncOnPaidNetwork" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Personalization" /v "Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\BrowserSettings" /v "Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Credentials" /v "Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Accessibility" /v "Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Windows" /v "Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync" /v "SyncPolicy" /t REG_DWORD /d "5" /f > nul

echo]
echo Disabling location and sensors
reg add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocationScripting" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableLocation" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableWindowsLocationProvider" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\LocationAndSensors" /v "DisableSensors" /t REG_DWORD /d "1" /f > nul

echo]
echo Power
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "EnergyEstimationEnabled" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\System\CurrentControlSet\Control\Power" /v "CsEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "EventProcessorEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v "PowerThrottlingOff" /t REG_DWORD /d "1" /f > nul

echo]
echo Location Tracking
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Turn off "Look For An App In The Store" option
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d 1 /f > nul

echo]
echo Do not show recently used files in Quick Access
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f > nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f > nul
if not %PROCESSOR_ARCHITECTURE%==x86 (
    reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f > nul
)

echo]
echo Disable ReadyBoost ^& get rid of tab
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f >nul 2>nul
:: ReadyBoost and memory compression
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\rdyboost" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Services\SysMain" /v "Start" /t REG_DWORD /d "4" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "GroupPolicyDisallowCaches" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "AllowNewCachesByDefault" /t REG_DWORD /d "0" /f > nul
echo]
echo Disabling memory compression...
echo Might error out here, no problem though, because the service is disabled.
powershell -NoProfile -Command "Disable-MMAgent -mc" >nul 2>nul

echo]
echo PowerShell execution policy - unrestricted
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t REG_SZ /d "Unrestricted" /f > nul

echo]
echo Hide "Meet Now" button. For future proofing
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable Shared Experiences
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f > nul

echo]
echo Internet Explorer QoL
:: Internet Explorer still sorta exists in Windows 11 in a weird way, keeping this here
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "NoUpdateCheck" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Enable Browser Extensions" /t REG_SZ /d "no" /f > nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation" /t REG_SZ /d "PMEM" /f > nul
reg add "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Isolation64Bit" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\BrowserEmulation" /v "IntranetCompatibilityMode" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer" /v "DisableFlashInIE" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\SQM" /v "DisableCustomerImprovementProgram" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\DomainSuggestion" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableFixSecuritySettings" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "EnableInPrivateBrowsing" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Privacy" /v "ClearBrowsingHistoryOnExit" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "EnableAutoUpgrade" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "DisableFirstRunCustomize" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Main" /v "HideNewEdgeButton" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feed Discovery" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Feeds" /v "BackgroundSyncStatus" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\FlipAhead" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Suggested Sites" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\TabbedBrowsing" /v "NewTabPageShow" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel" /v "HomePage" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v "Start Page" /t REG_SZ /d "https://www.search.brave.com" /f > nul

echo]
echo Disable 'Open File - Security Warning' message
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" /v "SaveZoneInformation" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Internet Explorer\Security" /v "DisableSecuritySettingsCheck" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1806" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1806" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1806" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1806" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\4" /v "1806" /t REG_DWORD /d "0" /f > nul

echo]
echo Show all tasks on control panel, credits to TenForums
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f > nul
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "InfoTip" /t REG_SZ /d "View list of all Control Panel tasks" /f > nul
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /v "System.ControlPanel.Category" /t REG_SZ /d "5" /f > nul
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\imageres.dll,-27" /f > nul
reg add "HKLM\Software\Classes\CLSID\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED7BA470-8E54-465E-825C-99712043E01C}" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{D15ED2E1-C75B-443c-BD7C-FC03B2F08C17}" /ve /t REG_SZ /d "All Tasks" /f > nul

:UWP-features-debloat-POST
echo]
echo Debloating
echo ---------------------------------------

echo]
echo Remove UWP bloat
echo Most of the UWP bloat (if not all) should be stripped with NTLite, this section is mostly for when you update and the bloat reinstalls
setlocal DisableDelayedExpansion
:: https://privacy.sexy/
echo Teams
powershell -NoProfile -NoLogo -Command "get-appxpackage *teams* | remove-appxpackage"
echo Cortana
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.549981C3F5F10' | Remove-AppxPackage"
echo MSN News
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.BingNews' | Remove-AppxPackage"
echo MSN Weather
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.BingWeather' | Remove-AppxPackage"
echo Bio enrollment app (breaks biometric authentication)
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.BioEnrollment'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Get Help app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.GetHelp' | Remove-AppxPackage"
echo Power Automate
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.PowerAutomateDesktop' | Remove-AppxPackage"
echo Microsoft Edge (Legacy) app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdge'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Microsoft Edge (Legacy) Dev Tools Client app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.MicrosoftEdgeDevToolsClient'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo My People / People Bar App on taskbar (People Experience Host)
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.PeopleExperienceHost'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Secondary Tile Experience app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.SecondaryTileExperience'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Secure Assessment Browser app (breaks Microsoft Intune/Graph)
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.SecureAssessmentBrowser'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Microsoft To Do app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.Todos' | Remove-AppxPackage"
echo Assigned Access Lock App app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.AssignedAccessLockApp'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Content Delivery Manager app (automatically installs apps)
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ContentDeliveryManager'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Windows 10 Family Safety / Parental Controls app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.Windows.ParentalControls'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Windows Feedback app
powershell -NoProfile -NoLogo -Command "$package = Get-AppxPackage -AllUsers 'Microsoft.WindowsFeedback'; if (!$package) {; Write-Host 'Not installed'; exit 0; }; $directories = @($package.InstallLocation, "^""$env:LOCALAPPDATA\Packages\$($package.PackageFamilyName)"^""); foreach($dir in $directories) {; if ( !$dir -Or !(Test-Path "^""$dir"^"") ) { continue }; cmd /c ('takeown /f "^""' + $dir + '"^"" /r /d y 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; cmd /c ('icacls "^""' + $dir + '"^"" /grant administrators:F /t 1> nul'); if($LASTEXITCODE) { throw 'Failed to take ownership' }; $files = Get-ChildItem -File -Path $dir -Recurse -Force; foreach($file in $files) {; if($file.Name.EndsWith('.OLD')) { continue }; $newName =  $file.FullName + '.OLD'; Write-Host "^""Rename '$($file.FullName)' to '$newName'"^""; Move-Item -LiteralPath "^""$($file.FullName)"^"" -Destination "^""$newName"^"" -Force; }; }"
echo Windows Voice Recorder app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.WindowsSoundRecorder' | Remove-AppxPackage"
echo Your Phone Companion app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.WindowsPhone' | Remove-AppxPackage"
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.Windows.Phone' | Remove-AppxPackage"
echo Communications - Phone app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.CommsPhone' | Remove-AppxPackage"
echo Your Phone app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.YourPhone' | Remove-AppxPackage"
echo Groove Music app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.ZuneMusic' | Remove-AppxPackage"
echo Movies and TV app
powershell -NoProfile -NoLogo -Command "Get-AppxPackage 'Microsoft.ZuneVideo' | Remove-AppxPackage"

REM I need to redo this...

REM echo]
REM echo Remove capabilites
REM %delCapabilty% OneCoreUAP.OneSync
REM %delCapabilty% Browser.InternetExplorer
REM %delCapabilty% MathRecognizer
REM %delCapabilty% Microsoft.Windows.WordPad
REM %delCapabilty% Hello.Face
REM %delCapabilty% Print.Fax.Scan
REM %delCapabilty% App.StepsRecorder
REM %delCapabilty% Windows.Kernel.LA57
REM %delCapabilty% Microsoft.WebDriver

REM %delCapabilty% App.Support.QuickAssist
REM %delCapabilty% MicrosoftWindowsPowerShellV2
REM %delCapabilty% MicrosoftWindowsPowerShellV2Root
REM %delCapabilty% WorkFolders-Client
REM %delCapabilty% SearchEngine-Client-Package
REM %delCapabilty% SmbDirect
REM %delCapabilty% MSRDC-Infrastructure
REM %delCapabilty% Printing-XPSServices-Features
REM %delCapabilty% Printing-PrintToPDFServices-Features

setlocal EnableDelayedExpansion

:tweaks4-POST
echo]
echo Mitigations
echo ---------------------------------------

echo]
echo Memory Management
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverride" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "FeatureSettingsOverrideMask" /t REG_DWORD /d "3" /f > nul
:: reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableCfg" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePageCombining" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "MoveImages" /t REG_DWORD /d "0" /f > nul
:: reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "DisablePagingExecutive" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable Fault Tolerant Heap
:: https://docs.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap
:: Doc listed as only affected in windows 7, is also in 7+
reg add "HKLM\Software\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d "0" /f > nul

:: https://docs.microsoft.com/en-us/windows/security/threat-protection/overview-of-threat-mitigations-in-windows-10#structured-exception-handling-overwrite-protection
:: Not found in ntoskrnl strings, very likely depracated or never existed. It is also disabled in MitigationOptions below.
:: reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "KernelSEHOPEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Exception Chain Validation
:: Exists in ntoskrnl strings, keep for now.
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableExceptionChainValidation" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable most mitigiations
:: Find correct mitigation values for different windows versions - AMIT
:: initialize bit mask in registry by disabling a random mitigation
powershell -NoProfile -Command Set-ProcessMitigation -System -Disable CFG
:: get bit mask
for /f "tokens=3 skip=2" %%a in ('reg query "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "MitigationAuditOptions"') do set mitigation_mask=%%a
:: set all bits to 2 (disable)
for /L %%a in (0,1,9) do (
    set mitigation_mask=!mitigation_mask:%%a=2!
)

echo]
echo Enabling CFG For Valorant and Vanguard
powershell -NoProfile -Command "Set-ProcessMitigation -Name vgc.exe -Enable CFG; Set-ProcessMitigation -Name valorant-win64-shipping.exe -Enable CFG; Set-ProcessMitigation -Name valorant.exe -Enable CFG; Set-ProcessMitigation -Name vgtray.exe -Enable CFG"

echo]
echo Disable TSX (security)
:: https://www.intel.com/content/www/us/en/support/articles/000059422/processors.html
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable HypervisorEnforcedCodeIntegrity
:: https://docs.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity
reg add "HKLM\System\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Even more tweaks?
echo -----------------------------

echo]
echo MMCSS
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NetworkThrottlingIndex" /t REG_DWORD /d "10" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "SystemResponsiveness" /t REG_DWORD /d "10" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "NoLazyMode" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v "LazyModeTimeout" /t REG_DWORD /d "10000" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "NoLazyMode" /t REG_DWORD /d "1" /f > nul

echo]
echo GameBar/FSE
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "ShowStartupPanel" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "GamePanelStartupTipIndex" /t REG_DWORD /d "3" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_Enabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehaviorMode" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_FSEBehavior" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_HonorUserFSEBehaviorMode" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_DXGIHonorFSEWindowsCompatible" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_EFSEFeatureFlags" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\System\GameConfigStore" /v "GameDVR_DSEBehavior" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" /v "AppCaptureEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "__COMPAT_LAYER" /t REG_SZ /d "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" /f > nul

echo]
echo Make passwords never expire...
net accounts /maxpwage:unlimited > nul

echo]
echo Disallow Background Apps
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul

:: https://docs.google.com/spreadsheets/d/1ZWQFycOWdODkUOuYZCxm5lTp08V2m7gjZQSCjywAsl8/edit#gid=762933934
echo]
echo Set Win32PrioritySeparation 0x2A
:: 0x2A-Short-Fixed-High foreground boost
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "42" /f > nul

:: Disable Notification/Action Center
:: %currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "0" /f
:: %currentuser% reg add "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d "1" /f

echo]
echo Disable Live Tiles push notifications
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v "NoTileApplicationNotification" /t REG_DWORD /d 1 /f > nul

echo]
echo Hung Apps, Wait to Kill, QoL
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "AutoEndTasks" /t REG_SZ /d "1" /f > nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "HungAppTimeout" /t REG_SZ /d "1000" /f > nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d "8" /f > nul
reg add "HKLM\System\CurrentControlSet\Control" /v "WaitToKillServiceTimeout" /t REG_SZ /d "2000" /f > nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9A12038010000000" /f > nul
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f > nul

echo]
echo Visual
%currentuser% reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_SZ /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f > nul

echo]
echo DWM
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f > nul
:: Needs testing
:: https://djdallmann.github.io/GamingPCSetup/CONTENT/RESEARCH/FINDINGS/registrykeys_dwm.txt
:: reg add "HKLM\Software\Microsoft\Windows\Dwm" /v "AnimationAttributionEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Add reg to new file menu
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f > nul
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul

echo]
echo Disable Storage Sense
reg add "HKLM\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Maintenance
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f > nul

echo]
echo Do not reduce sounds while in a call
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d "3" /f > nul

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

echo]
echo Install .cab context menu
reg delete "HKCR\CABFolder\Shell\RunAs" /f >nul 2>nul
reg add "HKCR\CABFolder\Shell\RunAs" /ve /t REG_SZ /d "Install" /f > nul
reg add "HKCR\CABFolder\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "" /f > nul
reg add "HKCR\CABFolder\Shell\RunAs\Command" /ve /t REG_SZ /d "cmd /k dism /online /add-package /packagepath:\"%%1\"" /f > nul

echo]
echo "Merge as System" for .regs
reg add "HKCR\regfile\Shell\RunAs" /ve /t REG_SZ /d "Merge As System" /f > nul
reg add "HKCR\regfile\Shell\RunAs" /v "HasLUAShield" /t REG_SZ /d "1" /f > nul
reg add "HKCR\regfile\Shell\RunAs\Command" /ve /t REG_SZ /d "nsudo -U:T -P:E reg import "%%1"" /f > nul

echo]
echo Remove include in library context menu
reg delete "HKCR\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul
reg delete "HKLM\SOFTWARE\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f >nul 2>nul

echo]
echo Remove Share in context menu
reg delete "HKCR\*\shellex\ContextMenuHandlers\ModernSharing" /f >nul 2>nul

echo]
echo Double click to import power plans
reg add "HKLM\Software\Classes\powerplan\DefaultIcon" /ve /t REG_SZ /d "%%WinDir%%\System32\powercpl.dll,1" /f > nul
reg add "HKLM\Software\Classes\powerplan\Shell\open\command" /ve /t REG_SZ /d "powercfg /import \"%%1\"" /f > nul
reg add "HKLM\Software\Classes\.pow" /ve /t REG_SZ /d "powerplan" /f > nul
reg add "HKLM\Software\Classes\.pow" /v "FriendlyTypeName" /t REG_SZ /d "PowerPlan" /f > nul


echo]
echo Disable DmaRemapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f
)

echo]
echo Set CSRSS to high
:: CSRSS is responsible for mouse input, setting to high may yield an improvement in input latency
:: Matches DWM priority
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f > nul

echo]
echo Clear main telemetry file
if exist "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" (
    takeown /f "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /r /d y
    icacls "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /grant administrators:F /t
    echo "" > "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
    echo Clear successful: "%ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl"
) else (
    echo Main telemetry file does not exist. Good!
)
echo Disable AutoLogger-Diagtrack-Listener
reg add "HKLM\System\CurrentControlSet\Control\WMI\Autologger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f


echo]
echo Clear Windows temp files
del /f /q %localappdata%\Temp\* >nul 2>nul
rd /s /q "%WINDIR%\Temp" >nul 2>nul
rd /s /q "%TEMP%" >nul 2>nul

echo]
echo Set System Processes Priority below normal
for %%i in (lsass.exe sppsvc.exe SearchIndexer.exe fontdrvhost.exe sihost.exe ctfmon.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f > nul
)
echo]
echo Set background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f > nul
)
:: Set DWM to normal
:: wmic process where name="dwm.exe" CALL setpriority "normal"

echo]
echo Boot configuration
echo -----------------------------
echo]

:: https://docs.google.com/spreadsheets/d/1ZWQFycOWdODkUOuYZCxm5lTp08V2m7gjZQSCjywAsl8/edit#gid=1190036594
:: https://sites.google.com/view/melodystweaks/basictweaks
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set
echo Lowering dual boot choice time
:: No, this does NOT affect single OS boot time.
bcdedit /timeout 10 > nul
:: Setting to No provides worse results, delete the value instead.
:: This is here as a safeguard incase of User Error.
bcdedit /deletevalue useplatformclock >nul 2>nul
echo Disable synthetic timer
bcdedit /set useplatformtick yes > nul
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set#additional-settings
:: Increases latency
:: bcdedit /set disabledynamictick Yes
echo Disable DEP
:: https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention
bcdedit /set nx AlwaysOff > nul
:: echo]
:: echo Hyper-V support is disabled by default
:: bcdedit /set hypervisorlaunchtype off
echo Use legacy boot menu
bcdedit /set bootmenupolicy Legacy > nul
echo Make dual boot menu more descriptive
bcdedit /set description duckISO %os% %version% > nul
echo Lower latency - tscsyncpolicy
bcdedit /set tscsyncpolicy Enhanced > nul
echo Disable 57-bits 5-level paging
bcdedit /set linearaddress57 OptOut > nul
bcdedit /set increaseuserva 268435328 > nul
echo Avoid the use of uncontiguous portions of low-memory from the OS
echo Causes system freezes on unstable memory sticks
bcdedit /set firstmegabytepolicy UseAll > nul
bcdedit /set avoidlowmemory 0x8000000 > nul
echo Disable some of the kernel memory mitigations
echo Causes boot crash/loops if Intel SGX
bcdedit /set allowedinmemorysettings 0x0 > nul
bcdedit /set isolatedcontext No > nul
echo Disable DMA memory protection and cores isolation
bcdedit /set vsmlaunchtype Off > nul
bcdedit /set vm No > nul
echo Disable automatic repair - it normally doesn't do much to help
:: https://winaero.com/how-to-disable-automatic-repair-at-windows-10-boot/
bcdedit /set {current} bootstatuspolicy IgnoreAllFailures > nul
echo Disable boot logo
bcdedit /set {globalsettings} custom:16000067 true > nul
echo Disable the spinning/loading animation
bcdedit /set {globalsettings} custom:16000069 true > nul

:tweaks5-POST
echo]
echo Hardening...
echo --------------------------------
:: LARGELY based on https://gist.github.com/ricardojba/ecdfe30dadbdab6c514a530bc5d51ef6

echo]
echo Firewall rules (blocking apps that shouldn't have internet access)
netsh Advfirewall set allprofiles state on > nul
set firewallblock=netsh advfirewall firewall add rule
set firewallblock2=protocol=tcp dir=out enable=yes action=block profile=any
%firewallblock% name="Block calc.exe netconns" program="%WinDir%\System32\calc.exe" %firewallblock2% > nul
%firewallblock% name="Block certutil.exe netconns" program="%WinDir%\System32\certutil.exe" %firewallblock2% > nul
%firewallblock% name="Block cmstp.exe netconns" program="%WinDir%\System32\cmstp.exe" %firewallblock2% > nul
%firewallblock% name="Block cscript.exe netconns" program="%WinDir%\System32\cscript.exe" %firewallblock2% > nul
%firewallblock% name="Block esentutl.exe netconns" program="%WinDir%\System32\esentutl.exe" %firewallblock2% > nul
%firewallblock% name="Block expand.exe netconns" program="%WinDir%\System32\expand.exe" %firewallblock2% > nul
%firewallblock% name="Block extrac32.exe netconns" program="%WinDir%\System32\extrac32.exe" %firewallblock2% > nul
%firewallblock% name="Block findstr.exe netconns" program="%WinDir%\System32\findstr.exe" %firewallblock2% > nul
%firewallblock% name="Block hh.exe netconns" program="%WinDir%\System32\hh.exe" %firewallblock2% > nul
%firewallblock% name="Block makecab.exe netconns" program="%WinDir%\System32\makecab.exe" %firewallblock2% > nul
%firewallblock% name="Block mshta.exe netconns" program="%WinDir%\System32\mshta.exe" %firewallblock2% > nul
%firewallblock% name="Block msiexec.exe netconns" program="%WinDir%\System32\msiexec.exe" %firewallblock2% > nul
%firewallblock% name="Block nltest.exe netconns" program="%WinDir%\System32\nltest.exe" %firewallblock2% > nul
%firewallblock% name="Block Notepad.exe netconns" program="%WinDir%\System32\notepad.exe" %firewallblock2% > nul
%firewallblock% name="Block pcalua.exe netconns" program="%WinDir%\System32\pcalua.exe" %firewallblock2% > nul
%firewallblock% name="Block print.exe netconns" program="%WinDir%\System32\print.exe" %firewallblock2% > nul
%firewallblock% name="Block regsvr32.exe netconns" program="%WinDir%\System32\regsvr32.exe" %firewallblock2% > nul
%firewallblock% name="Block replace.exe netconns" program="%WinDir%\System32\replace.exe" %firewallblock2% > nul
%firewallblock% name="Block rundll32.exe netconns" program="%WinDir%\System32\rundll32.exe" %firewallblock2% > nul
%firewallblock% name="Block runscripthelper.exe netconns" program="%WinDir%\System32\runscripthelper.exe" %firewallblock2% > nul
%firewallblock% name="Block scriptrunner.exe netconns" program="%WinDir%\System32\scriptrunner.exe" %firewallblock2% > nul
%firewallblock% name="Block SyncAppvPublishingServer.exe netconns" program="%WinDir%\System32\SyncAppvPublishingServer.exe" %firewallblock2% > nul
%firewallblock% name="Block wmic.exe netconns" program="%WinDir%\System32\wbem\wmic.exe" %firewallblock2% > nul
%firewallblock% name="Block wscript.exe netconns" program="%WinDir%\System32\wscript.exe" %firewallblock2% > nul
%firewallblock% name="Block regasm.exe netconns" program="%WinDir%\System32\regasm.exe" %firewallblock2% > nul
%firewallblock% name="Block odbcconf.exe netconns" program="%WinDir%\System32\odbcconf.exe" %firewallblock2% > nul
%firewallblock% name="Block regasm.exe netconns" program="%WinDir%\SysWOW64\regasm.exe" %firewallblock2% > nul
%firewallblock% name="Block odbcconf.exe netconns" program="%WinDir%\SysWOW64\odbcconf.exe" %firewallblock2% > nul
%firewallblock% name="Block calc.exe netconns" program="%WinDir%\SysWOW64\calc.exe" %firewallblock2% > nul
%firewallblock% name="Block certutil.exe netconns" program="%WinDir%\SysWOW64\certutil.exe" %firewallblock2% > nul
%firewallblock% name="Block cmstp.exe netconns" program="%WinDir%\SysWOW64\cmstp.exe" %firewallblock2% > nul
%firewallblock% name="Block cscript.exe netconns" program="%WinDir%\SysWOW64\cscript.exe" %firewallblock2% > nul
%firewallblock% name="Block esentutl.exe netconns" program="%WinDir%\SysWOW64\esentutl.exe" %firewallblock2% > nul
%firewallblock% name="Block expand.exe netconns" program="%WinDir%\SysWOW64\expand.exe" %firewallblock2% > nul
%firewallblock% name="Block extrac32.exe netconns" program="%WinDir%\SysWOW64\extrac32.exe" %firewallblock2% > nul
%firewallblock% name="Block findstr.exe netconns" program="%WinDir%\SysWOW64\findstr.exe" %firewallblock2% > nul
%firewallblock% name="Block hh.exe netconns" program="%WinDir%\SysWOW64\hh.exe" %firewallblock2% > nul
%firewallblock% name="Block makecab.exe netconns" program="%WinDir%\SysWOW64\makecab.exe" %firewallblock2% > nul
%firewallblock% name="Block mshta.exe netconns" program="%WinDir%\SysWOW64\mshta.exe" %firewallblock2% > nul
%firewallblock% name="Block msiexec.exe netconns" program="%WinDir%\SysWOW64\msiexec.exe" %firewallblock2% > nul
%firewallblock% name="Block nltest.exe netconns" program="%WinDir%\SysWOW64\nltest.exe" %firewallblock2% > nul
%firewallblock% name="Block Notepad.exe netconns" program="%WinDir%\SysWOW64\notepad.exe" %firewallblock2% > nul
%firewallblock% name="Block pcalua.exe netconns" program="%WinDir%\SysWOW64\pcalua.exe" %firewallblock2% > nul
%firewallblock% name="Block print.exe netconns" program="%WinDir%\SysWOW64\print.exe" %firewallblock2% > nul
%firewallblock% name="Block regsvr32.exe netconns" program="%WinDir%\SysWOW64\regsvr32.exe" %firewallblock2% > nul
%firewallblock% name="Block replace.exe netconns" program="%WinDir%\SysWOW64\replace.exe" %firewallblock2% > nul
%firewallblock% name="Block rpcping.exe netconns" program="%WinDir%\SysWOW64\rpcping.exe" %firewallblock2% > nul
%firewallblock% name="Block rundll32.exe netconns" program="%WinDir%\SysWOW64\rundll32.exe" %firewallblock2% > nul
%firewallblock% name="Block runscripthelper.exe netconns" program="%WinDir%\SysWOW64\runscripthelper.exe" %firewallblock2% > nul
%firewallblock% name="Block scriptrunner.exe netconns" program="%WinDir%\SysWOW64\scriptrunner.exe" %firewallblock2% > nul
%firewallblock% name="Block SyncAppvPublishingServer.exe netconns" program="%WinDir%\SysWOW64\SyncAppvPublishingServer.exe" %firewallblock2% > nul
%firewallblock% name="Block wmic.exe netconns" program="%WinDir%\SysWOW64\wbem\wmic.exe" %firewallblock2% > nul
%firewallblock% name="Block wscript.exe netconns" program="%WinDir%\SysWOW64\wscript.exe" %firewallblock2% > nul

echo]
echo Disable TsX to mitigate ZombieLoad, should be ideally disabled by microcode (update your BIOS)
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\kernel" /v "DisableTsx" /t REG_DWORD /d "1" /f > nul

echo]
echo Harden lsass to help protect against credential dumping (Mimikatz)
:: Configures lsass.exe as a protected process and disables wdigest
:: Enables delegation of non-exported credentials which enables support for Restricted Admin Mode or Remote Credential Guard
:: https://technet.microsoft.com/en-us/library/dn408187(v=ws.11).aspx
:: https://medium.com/blue-team/preventing-mimikatz-attacks-ed283e7ebdd5
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\lsass.exe" /v "AuditLevel" /t REG_DWORD /d "8" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\CredentialsDelegation" /v "AllowProtectedCreds" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdminOutboundCreds" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "DisableRestrictedAdmin" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RunAsPPL" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "Negotiate" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\SecurityProviders\WDigest" /v "UseLogonCredential" /t REG_DWORD /d "0" /f > nul

echo]
echo Harden WinRM
:: Do not allow unencrypted traffic
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" /v AllowUnencryptedTraffic /t REG_DWORD /d 0 /f > nul
:: Disable WinRM Client Digiest authentication
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client" /v AllowDigest /t REG_DWORD /d 0 /f > nul
:: Disabling RPC usage from a remote asset interacting with scheduled tasks
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule" /v DisableRpcOverTcp /t REG_DWORD /d 1 /f > nul
:: Disabling RPC usage from a remote asset interacting with services
reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v DisableRemoteScmEndpoints /t REG_DWORD /d 1 /f > nul

echo]
echo Disable NetBios for all interfaces
PowerShell -ExecutionPolicy Unrestricted -Command "$key = 'HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces'; Get-ChildItem $key | ForEach {; Set-ItemProperty -Path "^""$key\$($_.PSChildName)"^"" -Name NetbiosOptions -Value 2 -Verbose; }" > nul

echo]
echo Disable NTLMv1
powershell.exe Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\mrxsmb10" /v Start /t REG_DWORD /d 4 /f > nul

echo]
echo Disable PowerShell v2
:: Should already be disabled
powershell.exe Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2 > nul
powershell.exe Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2Root > nul

echo]
echo Disable IPv6
reg add "HKLM\SYSTEM\CurrentControlSet\services\tcpip6\parameters" /v DisabledComponents /t REG_DWORD /d 0xFF /f > nul

echo]
echo Prevent local windows wireless exploitation
:: the Airstrike attack https://shenaniganslabs.io/2021/04/13/Airstrike.html
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v DontDisplayNetworkSelectionUI /t REG_DWORD /d 1 /f > nul

echo]
echo General hardening
:: Prevent Kerberos from using DES or RC4
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters" /v SupportedEncryptionTypes /t REG_DWORD /d 2147483640 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v EnableMulticast /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\DNSClient" /v DisableSmartNameResolution /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v DisableParallelAandAAAA /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v IGMPLevel /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableIPSourceRouting /t REG_DWORD /d 2 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableICMPRedirect /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisableIPSourceRouting /t REG_DWORD /d 2 /f > nul

echo]
echo Windows Remote Access Settings
:: Disable solicited remote assistance
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fAllowToGetHelp /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d 0 /f > nul
:: Require encrypted RPC connections to Remote Desktop
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services" /v fEncryptRPCTraffic /t REG_DWORD /d 1 /f > nul

echo]
echo Disable lockscreen camera
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d 1 /f > nul

echo]
echo Prevent the storage of the LAN Manager hash of password
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Lsa" /v "NoLMHash" /t REG_DWORD /d 1 /f > nul

echo]
echo Disable the Windows Connect Now wizard
reg add "HKLM\Software\Policies\Microsoft\Windows\WCN\UI" /v "DisableWcnUi" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableFlashConfigRegistrar" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableInBand802DOT11Registrar" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableUPnPRegistrar" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "DisableWPDRegistrar" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WCN\Registrars" /v "EnableRegistrars" /t REG_DWORD /d 0 /f > nul

echo]
echo Disable the ClickOnce trust prompt
:: this only partially mitigates the risk of malicious ClickOnce Appps - the ability to run the manifest is disabled, but hash retrieval is still possible
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v MyComputer /t REG_SZ /d "Disabled" /f > nul
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v LocalIntranet /t REG_SZ /d "Disabled" /f > nul
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v Internet /t REG_SZ /d "Disabled" /f > nul
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v TrustedSites /t REG_SZ /d "Disabled" /f > nul
reg add "HKLM\SOFTWARE\MICROSOFT\.NETFramework\Security\TrustManager\PromptingLevel" /v UntrustedSites /t REG_SZ /d "Disabled" /f > nul

echo]
echo Show known file extensions and hidden files
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSuperHidden" /t REG_DWORD /d 1 /f > nul

echo]
echo Biometrics
:: Disable biometrics
reg add "HKLM\Software\Policies\Microsoft\Biometrics" /v "Enabled" /t REG_DWORD /d "0" /f > nul
:: Enable anti-spoofing for facial recognition
reg add "HKLM\SOFTWARE\Policies\Microsoft\Biometrics\FacialFeatures" /v EnhancedAntiSpoofing /t REG_DWORD /d 1 /f > nul
:: Disable other camera use while screen is locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenCamera /t REG_DWORD /d 1 /f > nul
:: Prevent Windows app voice activation while locked
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsActivateWithVoiceAboveLock /t REG_DWORD /d 2 /f > nul
:: Prevent Windows app voice activation entirely (be mindful of those with accesibility needs)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsActivateWithVoice /t REG_DWORD /d 2 /f > nul

:: Also fixes Scoop installation on some installs!
echo]
echo Enabling Strong Authentication for .NET Framework 3.5
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727" /v SchUseStrongCrypto /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\.NETFramework\v2.0.50727" /v SystemDefaultTlsVersions /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" /v SchUseStrongCrypto /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\v2.0.50727" /v SystemDefaultTlsVersions /t REG_DWORD /d 1 /f > nul
echo]
echo Enabling Strong Authentication for .NET Framework 4.0/4.5.x
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" /v SchUseStrongCrypto /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\.NETFramework\v4.0.30319" /v SystemDefaultTlsVersions /t REG_DWORD /d 1 /f > nul

echo]
echo Mitigation for CVE-2021-40444 and other future ActiveX related attacks 
:: https://msrc.microsoft.com/update-guide/vulnerability/CVE-2021-40444
:: https://www.huntress.com/blog/cybersecurity-advisory-hackers-are-exploiting-cve-2021-40444
:: https://nitter.unixfox.eu/wdormann/status/1437530613536501765
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1001" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1001" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1001" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1001" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\0" /v "1004" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\1" /v "1004" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\2" /v "1004" /t REG_DWORD /d 00000003 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3" /v "1004" /t REG_DWORD /d 00000003 /f > nul

echo]
echo Prevent Edge from running in background
reg add "HKLM\Software\Policies\Microsoft\Edge" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "BackgroundModeEnabled" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "MetricsReportingEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SendSiteInfoToImproveServices" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Edge" /v "StartupBoostEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Edge/IE hardening
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SitePerProcess" /t REG_DWORD /d "0x00000001" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLVersionMin" /t REG_SZ /d "tls1.2^@" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "NativeMessagingUserLevelHosts" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenEnabled" /t REG_DWORD /d "0x00000001" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverride" /t REG_DWORD /d "0x00000001" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "PreventSmartScreenPromptOverrideForFiles" /t REG_DWORD /d "0x00000001" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SSLErrorOverrideAllowed" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "SmartScreenPuaEnabled" /t REG_DWORD /d "0x00000001" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Edge" /v "AllowDeletingBrowserHistory" /t REG_DWORD /d "0x00000000" /f > nul
:: Enable Notifications in IE when a site attempts to install software
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer" /v SafeForScripting /t REG_DWORD /d 0 /f > nul

:: echo]
:: echo Switch to CloudFlare DNS
:: powershell.exe -Command "$PhysAdapter = Get-NetAdapter -Physical;$PhysAdapter | Get-DnsClientServerAddress -AddressFamily IPv4 | Set-DnsClientServerAddress -ServerAddresses '1.1.1.1','1.0.0.1'" > nul
:: reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableAutoDoh /t REG_DWORD /d 2 /f > nul

echo]
echo Delete Adobe Font Type Manager
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Font Drivers" /v "Adobe Type Manager" /f > nul

echo]
echo Removal Media Settings - Disable Autorun/Autoplay on all drives
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoAutoplayfornonVolume /t REG_DWORD /d 1 /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0xff /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 0xff /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoAutorun /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRecentDocsHistory /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoRecentDocsMenu /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v ClearRecentDocsOnExit /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v DisableAutoplay /t REG_DWORD /d 1 /f > nul

echo]
echo Disable Camera Access when locked
reg add "HKLM\Software\Policies\Microsoft\Windows\Personalization" /v "NoLockScreenCamera" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable admin shares
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v "AutoShareWks" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Remote Assistance
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowFullControl" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\System\CurrentControlSet\Control\Remote Assistance" /v "fEnableChatControl" /t REG_DWORD /d "0" /f > nul

echo]
echo SMB Hardening
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220932
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "RestrictNullSessAccess" /t REG_DWORD /d "1" /f > nul
:: Disable SMB Compression (Possible SMBGhost Vulnerability workaround)
reg add "HKLM\System\CurrentControlSet\Services\LanManServer\Parameters" /v "DisableCompression" /t REG_DWORD /d "1" /f > nul

echo]
echo Restrict Enumeration of Anonymous SAM Accounts
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220929
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymousSAM" /t REG_DWORD /d "1" /f > nul
:: https://www.stigviewer.com/stig/windows_10/2021-03-10/finding/V-220930
reg add "HKLM\System\CurrentControlSet\Control\Lsa" /v "RestrictAnonymous" /t REG_DWORD /d "1" /f > nul

echo]
echo Harden NetBios
:: NetBios is disabled. If it manages to become enabled, protect against NBT-NS poisoning attacks
reg add "HKLM\System\CurrentControlSet\Services\NetBT\Parameters" /v "NodeType" /t REG_DWORD /d "2" /f > nul

echo]
echo Mitigate against HiveNightmare^/SeriousSAM
icacls %windir%\system32\config\*.* /inheritance:e > nul

:tweaks6-POST
echo]
echo Context menu ^& some QoL tweaks
echo -----------------------------

echo]
echo Disable Network Navigation pane in file explorer
reg add "HKCR\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\ShellFolder" /v "Attributes" /t REG_DWORD /d "2962489444" /f > nul

echo]
echo Disable file sharing and enable firewall for all profiles
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\PublicProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "DisableNotifications" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\DomainProfile" /v "EnableFirewall" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable folders in 'This PC'
:: Credit to Shawn Brink
:: https://www.tenforums.com/tutorials/6015-add-remove-folders-pc-windows-10-a.html
echo Disable 3D Objects
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable music
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable downloads
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{7d83ee9b-2244-4e70-b1f5-5393042af1e4}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable pictures
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{0ddd015d-b06c-45d5-8c4c-f59713854639}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable videos
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable documents
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{f42ee2d3-909f-4907-8871-4c22fc0bf756}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
echo Disable desktop
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}\PropertyBag" /v "ThisPCPolicy" /t REG_SZ /d "Hide" /f > nul

echo]
echo Enable full classic context menus in Windows 11
%currentuser% reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve > nul

echo]
echo Disable '- Shortcut' text added onto shortcuts
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "link" /t REG_BINARY /d "00000000" /f > nul

echo]
echo Disable modern standby
:: https://winaero.com/how-to-disable-modern-standby-in-windows-11-and-windows-10
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f > nul

echo]
echo Use the classic shortcut arrow
:: It is smaller, so you can see more of your actual application icon
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" /v "29" /t REG_EXPAND_SZ /d "C:\Windows\DuckModules\Other\classic.ico" /f > nul

echo]
echo Increase icon cache size
:: Can improve performance: https://winaero.com/change-icon-cache-size-windows-10/
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "8192" /f > nul

echo]
echo Disable jump lists
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f > nul

echo]
echo Decrease jump list size to 0
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JumpListItems_Maximum" /t REG_DWORD /d "0" /f > nul

echo]
echo Windows Update context menu on the desktop
:: Credit to Winaero Tweaker
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\shell32.dll,-47" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate" /v "Position" /t REG_SZ /d "Bottom" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate" /v "SubCommands" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate" /v "MUIVerb" /t REG_SZ /d "Windows Update" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\01WindowsUpdate" /v "MUIVerb" /t REG_SZ /d "Windows Update" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\01WindowsUpdate" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\bootux.dll,-1032" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\01WindowsUpdate" /v "SettingsURI" /t REG_SZ /d "ms-settings:windowsupdate" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\01WindowsUpdate\Command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\02CheckForUpdates" /v "SettingsURI" /t REG_SZ /d "ms-settings:windowsupdate-action" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\02CheckForUpdates" /v "MUIVerb" /t REG_SZ /d "Check for updates" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\02CheckForUpdates" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\bootux.dll,-1032" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\02CheckForUpdates\Command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\03UpdateHistory" /v "MUIVerb" /t REG_SZ /d "Update history" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\03UpdateHistory" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\bootux.dll,-1032" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\03UpdateHistory" /v "SettingsURI" /t REG_SZ /d "ms-settings:windowsupdate-history" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\03UpdateHistory\Command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\04RestartOptions" /v "SettingsURI" /t REG_SZ /d "ms-settings:windowsupdate-restartoptions" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\04RestartOptions" /v "MUIVerb" /t REG_SZ /d "Restart options" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\04RestartOptions" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\bootux.dll,-1032" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\04RestartOptions\Command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\05AdvancedOptions" /v "SettingsURI" /t REG_SZ /d "ms-settings:windowsupdate-options" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\05AdvancedOptions" /v "MUIVerb" /t REG_SZ /d "Advanced options" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\05AdvancedOptions" /v "Icon" /t REG_SZ /d "%%SystemRoot%%\\System32\\bootux.dll,-1032" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\WindowsUpdate\shell\05AdvancedOptions\Command" /v "DelegateExecute" /t REG_SZ /d "{556FF0D6-A1EE-49E5-9FA4-90AE116AD744}" /f > nul

echo]
echo Run as administrator for: .msi files, .vbs files and .ps1 files
:: Credit to Winaero Tweaker
reg add "HKLM\Software\Classes\Microsoft.PowerShellScript.1\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Microsoft.PowerShellScript.1\shell\runas\command" /ve /t REG_EXPAND_SZ /d "powershell.exe \"-Command\" \"if((Get-ExecutionPolicy ) -ne 'AllSigned') { Set-ExecutionPolicy -Scope Process Bypass }; ^& '%%1'\"" /f > nul
reg add "HKLM\Software\Classes\Msi.Package\shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Msi.Package\shell\runas\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\System32\msiexec.exe\" /i \"%%1\" %%*" /f > nul
reg add "HKLM\Software\Classes\VBSFile\Shell\runas" /v "HasLUAShield" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\VBSFile\Shell\runas\command" /ve /t REG_EXPAND_SZ /d "\"%%SystemRoot%%\System32\WScript.exe\" \"%%1\" %%*" /f > nul

echo]
echo Remove 'Cast to Device' from context menu
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{7AD84985-87B4-4a16-BE58-8B72A5B390F7}" /t REG_SZ /d "" /f > nul

echo]
echo Remove BitLocker context menu entries
reg add "HKLM\Software\Classes\Drive\shell\change-passphrase" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\change-pin" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\encrypt-bde" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\encrypt-bde-elev" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\manage-bde" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\resume-bde" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\resume-bde-elev" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\unlock-bde" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Edit with Photos' from context menu
reg add "HKCR\AppX43hnxtbyyps62jhe9sqpdzxn1790zetc\Shell\ShellEdit" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Edit with Paint 3D' from context menu
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.bmp\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpeg\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpe\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.jpg\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.png\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.gif\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tif\Shell\3D Edit" /f > nul
reg delete "HKLM\SOFTWARE\Classes\SystemFileAssociations\.tiff\Shell\3D Edit" /f > nul

echo]
echo Remove 'Extract All' from context menu (use 7-Zip)
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{b8cdcb65-b1bf-4b42-9428-1dfdb7ee92af}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Burn disc image' from context menu
reg add "HKLM\Software\Classes\Windows.IsoFile\shell\burn" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Share with/Give Access To' from context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{f81e9010-6ea4-11ce-a7ff-00aa003ca9f6}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Share' from context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{e2bf9676-5f8f-435c-97eb-11607a5bedf7}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Restore Previous Versions' from context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{596AB062-B4D2-4215-9F74-E9109B0A8153}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{596AB062-B4D2-4215-9F74-E9109B0A8153}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Troubleshoot Compability' from context menu
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{1d27f844-3a1f-4410-85ac-14651078412d}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Windows Media Player' from context menu
reg add "HKLM\Software\Classes\SystemFileAssociations\audio\shell\Enqueue" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\audio\shell\Play" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\Directory.Audio\shell\Enqueue" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\Directory.Audio\shell\Play" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\Directory.Image\shell\Enqueue" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\Directory.Image\shell\Play" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{8A734961-C4AA-4741-AC1E-791ACEBF5B39}" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Shell Extensions\Blocked" /v "{8A734961-C4AA-4741-AC1E-791ACEBF5B39}" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Include in library' from context menu
reg delete "HKLM\Software\Classes\Folder\ShellEx\ContextMenuHandlers\Library Location" /f > nul

echo]
echo Remove 'Rotate Left/Right' from context menu
reg add "HKLM\Software\Classes\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.bmp\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.dib\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.gif\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.heic\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.heif\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.ico\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jfif\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.png\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.rle\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.tif\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.tiff\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /ve /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\.webp\ShellEx\ContextMenuHandlers\ShellImagePreview" /v "CLSID_value" /t REG_SZ /d "{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}" /f > nul

echo]
echo Remove 'File Ownership EFS' from context menu
reg add "HKLM\Software\Classes\*\shell\UpdateEncryptionSettingsWork" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\UpdateEncryptionSettings" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Print' from context menu
reg add "HKLM\Software\Classes\batfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\cmdfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\docxfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\fonfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\htmlfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\InternetShortcut\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\JSEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\pfmfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\regfile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\rtffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\SystemFileAssociations\image\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\ttffile\shell\print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\VBEFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\VBSFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\WSFFile\Shell\Print" /v "ProgrammaticAccessOnly" /t REG_SZ /d "" /f > nul

echo]
echo Remove 'Bitmap Image' from the 'New' context menu
reg delete "HKCR\.bmp\ShellNew" /f > nul

echo]
echo Remove 'Rich Text Document' from 'New' context menu
reg delete "HKCR\.rtf\ShellNew" /f > nul

echo]
echo Remove 'Compressed zipped Folder' from 'New' context menu
reg delete "HKCR\.zip\CompressedFolder\ShellNew" /f > nul

echo]
echo Remove 'Customise this Folder' from context menu
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoCustomizeThisFolder" /t REG_DWORD /d "1" /f > nul

echo]
echo Add PowerShell as admin to extended context menu
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenPSAdmin" /ve /t REG_SZ /d "PowerShell (Admin)" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenPSAdmin" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenPSAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenPSAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenPSAdmin\command" /ve /t REG_SZ /d "powershell -WindowStyle Hidden -NoProfile -Command \"Start-Process -Verb RunAs powershell.exe -ArgumentList \\\"-NoExit -Command Push-Location \\\\\\\"\\\"%%V/\\\\\\\"\\\"\\\"" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenPSAdmin" /ve /t REG_SZ /d "PowerShell (Admin)" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenPSAdmin" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenPSAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenPSAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenPSAdmin\command" /ve /t REG_SZ /d "powershell -WindowStyle Hidden -NoProfile -Command \"Start-Process -Verb RunAs powershell.exe -ArgumentList \\\"-NoExit -Command Push-Location \\\\\\\"\\\"%%V/\\\\\\\"\\\"\\\"" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenPSAdmin" /ve /t REG_SZ /d "PowerShell (Admin)" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenPSAdmin" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenPSAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenPSAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenPSAdmin\command" /ve /t REG_SZ /d "powershell -WindowStyle Hidden -NoProfile -Command \"Start-Process -Verb RunAs powershell.exe -ArgumentList \\\"-NoExit -Command Push-Location \\\\\\\"\\\"%%V/\\\\\\\"\\\"\\\"" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\shell\OpenPSAdmin" /ve /t REG_SZ /d "PowerShell (Admin)" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\shell\OpenPSAdmin" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\shell\OpenPSAdmin" /v "HasLUAShield" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\shell\OpenPSAdmin" /v "Icon" /t REG_SZ /d "powershell.exe" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\shell\OpenPSAdmin\command" /ve /t REG_SZ /d "powershell -WindowStyle Hidden -NoProfile -Command \"Start-Process -Verb RunAs powershell.exe -ArgumentList \\\"-NoExit -Command Push-Location \\\\\\\"\\\"%%V/\\\\\\\"\\\"\\\"" /f

echo]
echo Add PowerShell to the extended context menu
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS" /v "Icon" /t REG_SZ /d "PowerShell.exe" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS" /ve /t REG_SZ /d "PowerShell" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\OpenPS\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS" /v "Icon" /t REG_SZ /d "PowerShell.exe" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS" /ve /t REG_SZ /d "PowerShell" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\OpenPS\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS" /ve /t REG_SZ /d "PowerShell" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS" /v "Icon" /t REG_SZ /d "PowerShell.exe" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\OpenPS\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS" /v "Icon" /t REG_SZ /d "PowerShell.exe" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS" /ve /t REG_SZ /d "PowerShell" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenPS\command" /ve /t REG_SZ /d "powershell.exe -noexit -command Set-Location -literalPath '%%V'" /f > nul

echo]
echo Add Command Prompt as admin to the extended context menu
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd" /v "Icon" /t REG_SZ /d "cmd.exe" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd" /ve /t REG_SZ /d "Command Prompt (Admin)" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd" /v "NeverDefault" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\background\shell\OpenElevatedCmd\command" /ve /t REG_SZ /d "PowerShell.exe -windowstyle hidden -Command \"Start-Process cmd.exe -ArgumentList '/s,/k,pushd,%%V' -Verb RunAs\"" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd" /ve /t REG_SZ /d "Command Prompt (Admin)" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd" /v "Icon" /t REG_SZ /d "cmd.exe" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd" /v "NeverDefault" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Directory\shell\OpenElevatedCmd\command" /ve /t REG_SZ /d "PowerShell.exe -windowstyle hidden -Command \"Start-Process cmd.exe -ArgumentList '/s,/k,pushd,%%V' -Verb RunAs\"" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd" /v "NeverDefault" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd" /v "Icon" /t REG_SZ /d "cmd.exe" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd" /ve /t REG_SZ /d "Command Prompt (Admin)" /f
>nul reg add "HKLM\Software\Classes\Drive\shell\OpenElevatedCmd\command" /ve /t REG_SZ /d "PowerShell.exe -windowstyle hidden -Command \"Start-Process cmd.exe -ArgumentList '/s,/k,pushd,%%V' -Verb RunAs\"" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd" /v "NeverDefault" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd" /v "Icon" /t REG_SZ /d "cmd.exe" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd" /v "Extended" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd" /v "NoWorkingDirectory" /t REG_SZ /d "" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd" /ve /t REG_SZ /d "Command Prompt (Admin)" /f
>nul reg add "HKLM\Software\Classes\LibraryFolder\Shell\OpenElevatedCmd\command" /ve /t REG_SZ /d "PowerShell.exe -windowstyle hidden -Command \"Start-Process cmd.exe -ArgumentList '/s,/k,pushd,%%V' -Verb RunAs\"" /f

echo]
echo Add Command Prompt to the extended context menu
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2" /v "Icon" /t REG_SZ /d "cmd.exe" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2" /ve /t REG_SZ /d "Command Prompt" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\background\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2" /v "Icon" /t REG_SZ /d "cmd.exe" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2" /ve /t REG_SZ /d "Command Prompt" /f > nul
reg add "HKLM\Software\Classes\Directory\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2" /v "Icon" /t REG_SZ /d "cmd.exe" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2" /ve /t REG_SZ /d "Command Prompt" /f > nul
reg add "HKLM\Software\Classes\Drive\shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2" /v "NeverDefault" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2" /v "NoWorkingDirectory" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2" /v "Extended" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2" /v "Icon" /t REG_SZ /d "cmd.exe" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2" /ve /t REG_SZ /d "Command Prompt" /f > nul
reg add "HKLM\Software\Classes\LibraryFolder\Shell\cmd2\command" /ve /t REG_SZ /d "cmd.exe /s /k pushd \"%%V\"" /f > nul

echo]
echo Add .bat, .cmd, .reg and .ps1 to the 'New' context menu
reg add "HKLM\Software\Classes\.bat\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\WINDOWS\System32\acppage.dll,-6002" /f > nul
reg add "HKLM\Software\Classes\.bat\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\.cmd\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\.cmd\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\WINDOWS\System32\acppage.dll,-6003" /f > nul
reg add "HKLM\Software\Classes\.ps1\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\.ps1\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "New file" /f > nul
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\WINDOWS\regedit.exe,-309" /f > nul

echo]
echo Set chkdsk timeout on boot to 50 seconds to avoid unwanted scanning
reg add "HKLM\System\ControlSet001\Control\Session Manager" /v "AutoChkTimeout" /t REG_DWORD /d "50" /f > nul

echo]
echo Show removable drivers only in 'This PC' on the Windows Explorer sidebar
reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f > nul
reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f > nul

echo]
echo Remove 'Network' from the Windows Explorer sidebar
%currentuser% reg add "HKCU\Software\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\WOW6432Node\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f > nul

echo]
echo Remove 'Libraries' from the Windows Explorer sidebar
%currentuser% reg add "HKCU\Software\Classes\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Classes\WOW6432Node\CLSID\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f > nul

echo] 
echo Add classic personalisation back to the Control Panel
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /v "InfoTip" /t REG_SZ /d "@%%SystemRoot%%\System32\themecpl.dll,-2#immutable1" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /v "System.ApplicationName" /t REG_SZ /d "Microsoft.Personalization" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /v "System.ControlPanel.Category" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /v "System.Software.TasksFileUrl" /t REG_SZ /d "Internal" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /ve /t REG_SZ /d "Personalisation (Classic)" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}\DefaultIcon" /ve /t REG_SZ /d "%%SystemRoot%%\System32\themecpl.dll,-1" /f > nul
reg add "HKLM\Software\Classes\CLSID\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}\Shell\Open\Command" /ve /t REG_SZ /d "explorer.exe shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ControlPanel\NameSpace\{580722FF-16A7-44C1-BF74-7E1ACD00F4F9}" /ve /t REG_SZ /d "Personalization" /f > nul

echo]
echo Disable automatic maintenence
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled " /t REG_DWORD /d "1" /f > nul

echo]
echo Safe mode desktop context menu
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode" /v "Icon" /t REG_SZ /d "shell32.dll,77" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode" /v "Position" /t REG_SZ /d "Bottom" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode" /v "SubCommands" /t REG_SZ /d "" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode" /v "MUIVerb" /t REG_SZ /d "Safe Mode" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\01SafeMode" /v "MUIVerb" /t REG_SZ /d "Safe Mode" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\01SafeMode\Command" /ve /t REG_SZ /d "cmd.exe /c \"C:\Users\Public\Desktop\duckISO\Troubleshooting\Safe Mode\Safe Mode.cmd\"" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\02SafeModeNet" /v "MUIVerb" /t REG_SZ /d "Safe Mode with Networking" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\02SafeModeNet\Command" /ve /t REG_SZ /d "cmd.exe /c \"C:\Users\Public\Desktop\duckISO\Troubleshooting\Safe Mode\Safe Mode with Networking.cmd\"" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\03SafeModeCmd" /v "MUIVerb" /t REG_SZ /d "Safe Mode with Command Prompt" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\03SafeModeCmd\Command" /ve /t REG_SZ /d "cmd.exe /c \"C:\Users\Public\Desktop\duckISO\Troubleshooting\Safe Mode\Safe Mode with Command Prompt.cmd\"" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\04SafeModeNormal" /v "MUIVerb" /t REG_SZ /d "Exit Safe Mode" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\04SafeModeNormal" /v "CommandFlags" /t REG_DWORD /d "32" /f > nul
reg add "HKLM\Software\Classes\DesktopBackground\Shell\SafeMode\shell\04SafeModeNormal\Command" /ve /t REG_SZ /d "cmd.exe /c \"C:\Users\Public\Desktop\duckISO\Troubleshooting\Safe Mode\Exit Safe Mode.cmd\"" /f > nul

echo]
echo Show seconds in taskbar clock
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowSecondsInSystemClock" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable search box suggestions/history
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable tooptips in File Explorer
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowInfoTip" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable advertisements via Bluetooth
reg add "HKLM\Software\Microsoft\PolicyManager\current\device\Bluetooth" /v "AllowAdvertising" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable syncing text messages
reg add "HKLM\Software\Policies\Microsoft\Windows\Messaging" /v "AllowMessageSync" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable text suggestions when typing on the software keyboard
%currentuser% reg add "HKCU\Software\Microsoft\TabletTip\1.7" /v "EnableTextPrediction" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable the transfer of the clipboard to other devices via the internet
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "AllowCrossDeviceClipboard" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable 'Meet Now' (current user)
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "HideSCAMeetNow" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable notifications on the lockscreen
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" /v "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable downloading of OneSettings config settings
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DisableOneSettingsDownloads" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable diagnostic log collection
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "LimitDiagnosticLogCollection" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable language settings sync
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /v "Enabled" /t REG_DWORD /d "0" /f > nul

echo]
echo App permissions
%currentuser% reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" /v "AgentActivationOnLockScreenEnabled" /t REG_DWORD /d "0" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\appDiagnostics" /v "Value" /t REG_SZ /d "Deny" /f > nul
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" /v "Value" /t REG_SZ /d "Deny" /f > nul

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
	echo This log keeps track of which scripts have been run. This is never transfered to an online resource and stays local. > C:\Windows\DuckModules\logs\userScript.log
	echo -------------------------------------------------------------------------------------------------------------------- >> C:\Windows\DuckModules\logs\userScript.log
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
powershell -NoProfile -EP Unrestricted -Command "C:\Windows\DuckModules\Get-ConsoleAsText.ps1" > "C:\Windows\DuckModules\logs\Post install log - %newdate% %newtime%.txt"

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
if %ERRORLEVEL%==0 echo %date% - %time% Notifications Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:notiE
sc config WpnUserService start=auto
sc config WpnService start=auto
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Policies\Microsoft\Windows\Explorer" /v "DisableNotificationCenter" /t REG_DWORD /d "0" /f
if %ERRORLEVEL%==0 echo %date% - %time% Notifications Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:indexD
sc config WSearch start=disabled
sc stop WSearch >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Search Indexing Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:indexE
sc config WSearch start=delayed-auto
sc start WSearch >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Search Indexing Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Wi-Fi Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Wi-Fi Enabled...>> C:\Windows\DuckModules\logs\userScript.log
sc config eventlog start=auto
echo %date% - %time% EventLog enabled as Wi-Fi dependency...>> C:\Windows\DuckModules\logs\userscript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Microsoft Store Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Microsoft Store Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:btD
sc config BthAvctpSvc start=disabled
sc stop BthAvctpSvc >nul 2>nul
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "4" /f
  sc stop %%~nI
)
sc config CDPSvc start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Bluetooth Disabled...>> C:\Windows\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish

:btE
sc config BthAvctpSvc start=auto
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f CDPUserSvc ^| find /i "CDPUserSvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "2" /f
)
sc config CDPSvc start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Bluetooth Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:cbdhsvcD
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "4" /f
)
:: TODO: check if can be set to demand
sc config DsSvc start=disabled
%currentuser% reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /t REG_DWORD /d "0" /f
if %ERRORLEVEL%==0 echo %date% - %time% Clipboard History Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:cbdhsvcE
for /f %%I in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /k /f cbdhsvc ^| find /i "cbdhsvc" ') do (
  reg add "%%I" /v "Start" /t REG_DWORD /d "3" /f
)
sc config DsSvc start=auto
%currentuser% reg add "HKCU\Software\Microsoft\Clipboard" /v "EnableClipboardHistory" /t REG_DWORD /d "1" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "AllowClipboardHistory" /f >nul 2>nul
if %ERRORLEVEL%==0 echo %date% - %time% Clipboard History Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:hddD
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f
sc config SysMain start=disabled
sc config FontCache start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Hard Drive Prefetch Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:hddE
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnablePrefetcher" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management" /v "EnableSuperfetch" /t REG_DWORD /d "1" /f
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "3" /f
sc config SysMain start=auto
sc config FontCache start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Hard Drive Prefetch Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:depE
powershell -NoProfile set-ProcessMitigation -System -Enable DEP
powershell -NoProfile set-ProcessMitigation -System -Enable EmulateAtlThunks
bcdedit /set nx OptIn
:: Enable CFG for Valorant related processes
for %%i in (valorant valorant-win64-shipping vgtray vgc) do (
  powershell -NoProfile -Command "Set-ProcessMitigation -Name %%i.exe -Enable CFG"
)
if %ERRORLEVEL%==0 echo %date% - %time% DEP Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:depD
echo If you get issues with some anti-cheats, please re-enable DEP.
powershell -NoProfile set-ProcessMitigation -System -Disable DEP
powershell -NoProfile set-ProcessMitigation -System -Disable EmulateAtlThunks
bcdedit /set nx AlwaysOff
if %ERRORLEVEL%==0 echo %date% - %time% DEP Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
chdir /d C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy

:restartStart
taskkill /F /IM StartMenuExperienceHost*
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old
:: Loop if it fails to rename the first time
if exist "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" goto restartStart
:: Rename Search
chdir /d C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy

:restartSearch
taskkill /F /IM SearchApp*  >nul 2>nul
ren SearchApp.exe SearchApp.old
:: Loop if it fails to rename the first time
if exist "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe" goto restartSearch
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:enableStart
:: Rename Start Menu
chdir /d C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
ren StartMenuExperienceHost.old StartMenuExperienceHost.exe
:: Rename Search
chdir /d C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy
ren SearchApp.old SearchApp.exe
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "1" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:openshellInstall
curl -L --output C:\Windows\DuckModules\oshellI.exe https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.8/OpenShellSetup_4_4_8.exe
IF EXIST "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy" goto existOS
IF EXIST "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy" goto existOS
goto rmSSOS

:existOS
set /P c=It appears Search and Start are installed, would you like to disable them also?[Y/N]?
if /I "%c%" EQU "Y" goto rmSSOS
if /I "%c%" EQU "N" goto skipRM

:rmSSOS
:: Rename Start Menu
chdir /d C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy

:OSrestartStart
taskkill /F /IM StartMenuExperienceHost*
ren StartMenuExperienceHost.exe StartMenuExperienceHost.old
:: Loop if it fails to rename the first time
if exist "C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\StartMenuExperienceHost.exe" goto OSrestartStart
:: Rename Search
chdir /d C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy

:OSrestartSearch
taskkill /F /IM SearchApp*  >nul 2>nul
ren SearchApp.exe SearchApp.old
:: Loop if it fails to rename the first time
if exist "C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy\SearchApp.exe" goto OSrestartSearch
:: Search Icon
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% Search and Start Menu Removed...>> C:\Windows\DuckModules\logs\userScript.log

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
if %ERRORLEVEL%==0 echo %date% - %time% Open-Shell Installed...>> C:\Windows\DuckModules\logs\userScript.log
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
ren C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.old
taskkill /F /IM SearchApp*  >nul 2>nul
ren C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy Microsoft.Windows.Search_cw5n1h2txyewy.old
ren C:\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy Microsoft.XboxGameCallableUI_cw5n1h2txyewy.old
ren C:\Windows\SystemApps\Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe.old

taskkill /F /IM RuntimeBroker*  >nul 2>nul
ren C:\Windows\System32\RuntimeBroker.exe RuntimeBroker.exe.old
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 0 /F
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% UWP Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
ren C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy.old Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
taskkill /F /IM SearchApp*  >nul 2>nul
ren C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy.old Microsoft.Windows.Search_cw5n1h2txyewy
ren C:\Windows\SystemApps\Microsoft.XboxGameCallableUI_cw5n1h2txyewy.old Microsoft.XboxGameCallableUI_cw5n1h2txyewy
ren C:\Windows\SystemApps\Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe.old Microsoft.XboxApp_48.49.31001.0_x64__8wekyb3d8bbwe
taskkill /F /IM RuntimeBroker*  >nul 2>nul
ren C:\Windows\System32\RuntimeBroker.exe.old RuntimeBroker.exe
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /V SearchboxTaskbarMode /T REG_DWORD /D 0 /F
taskkill /f /im explorer.exe
nsudo -U:C start explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% UWP Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% StartLayout Policy Removed...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Sleep States Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Sleep States Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:idleD
echo THIS WILL CAUSE YOUR CPU USAGE TO *DISPLAY* AS 100%. ENABLE IDLE IF THIS IS AN ISSUE.
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 1
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Idle Disabled...>> C:\Windows\DuckModules\logs\userScript.log

goto finishNRB
:idleE
powercfg -setacvalueindex scheme_current sub_processor 5d76a2ca-e8c0-402f-a133-2158492d58ad 0
powercfg -setactive scheme_current
if %ERRORLEVEL%==0 echo %date% - %time% Idle Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Xbox Related Apps and Services Removed...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:vcreR
echo Opening Visual C++ Runtimes installer...
vcredist.exe /ai
echo Installation done.
if %ERRORLEVEL%==0 echo %date% - %time% Visual C++ Runtimes installed...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% UAC Disabled...>> C:\Windows\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish

:uacE
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "EnableLUA" /t REG_DWORD /d "1" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f
reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "5" /f
reg add "HKLM\System\CurrentControlSet\Services\luafv" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\Appinfo" /v "Start" /t REG_DWORD /d "3" /f
if %ERRORLEVEL%==0 echo %date% - %time% UAC Enabled...>> C:\Windows\DuckModules\logs\userScript.log
if %settweaks%==0 goto finish
exit /b

:firewallD
reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "4" /f
if %ERRORLEVEL%==0 echo %date% - %time% Firewall Disabled...>> C:\Windows\DuckModules\logs\userScript.log
if "%~1" EQU "int" goto :EOF
goto finish
:firewallE
reg add "HKLM\System\CurrentControlSet\Services\mpssvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\BFE" /v "Start" /t REG_DWORD /d "2" /f
if %ERRORLEVEL%==0 echo %date% - %time% Firewall Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:aniE
reg delete "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /f >nul 2>nul
%currentuser% reg delete "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /f >nul 2>nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9e3e078012000000" /f
if %ERRORLEVEL%==0 echo %date% - %time% Animations Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:aniD
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f
%currentuser% reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v "MinAnimate" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAnimations" /t REG_DWORD /d "0" /f
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "3" /f
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "UserPreferencesMask" /t REG_BINARY /d "9012038010000000" /f
if %ERRORLEVEL%==0 echo %date% - %time% Animations Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:workstationD
reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "4" /f
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "4" /f
dism /Online /Disable-Feature /FeatureName:SmbDirect /norestart
if %ERRORLEVEL%==0 echo %date% - %time% Workstation Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:workstationE
reg add "HKLM\System\CurrentControlSet\Services\rdbss" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\KSecPkg" /v "Start" /t REG_DWORD /d "0" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb20" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\mrxsmb" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\srv2" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\LanmanWorkstation" /v "Start" /t REG_DWORD /d "2" /f
dism /Online /Enable-Feature /FeatureName:SmbDirect /norestart
if %ERRORLEVEL%==0 echo %date% - %time% Workstation Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Printing Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Printing Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Mouse Data Queue Size set to %c%...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Keyboard Data Queue Size set to %c%...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Network Setting Reset to Windows Default...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:netDuckDefault
echo]
echo Network Tweaks
echo --------------------------

echo]
echo Disabling Nagle's algorithm...
:: Disable Nagle's Algorithm
:: Helps with ping, reduces throughput
:: Note: does nothing to Minecraft
:: https://en.wikipedia.org/wiki/Nagle%27s_algorithm
for /f %%i in ('wmic path win32_networkadapter get GUID ^| findstr "{"') do (
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpAckFrequency" /t REG_DWORD /d "1" /f > nul
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TcpDelAckTicks" /t REG_DWORD /d "0" /f > nul
  reg add "HKLM\System\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%%i" /v "TCPNoDelay" /t REG_DWORD /d "1" /f > nul
)
echo]
echo General networking tweaks...
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosNonBestEffortLimit
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "NonBestEffortLimit" /t REG_DWORD /d "0" /f > nul
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Policies.QualityofService::QosTimerResolution
reg add "HKLM\Software\Policies\Microsoft\Windows\Psched" /v "TimerResolution" /t REG_DWORD /d "1" /f > nul
:: Required for DSCP policies
reg add "HKLM\System\CurrentControlSet\Services\Tcpip\QoS" /v "Do not use NLA" /t REG_DWORD /d "1" /f > nul
::reg add "HKLM\System\CurrentControlSet\Services\AFD\Parameters" /v "DoNotHoldNicBuffers" /t REG_DWORD /d "1" /f
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
:: Disable Network Adapters
:: IPv6, Client for Microsoft Networks, File and Printer Sharing, Link-Layer Topology Discovery Responder, Link-Layer Topology Discovery Mapper I/O Driver, Microsoft Network Adapter Multiplexor Protocol, Microsoft LLDP Protocol Driver
powershell -NoProfile -Command "Disable-NetAdapterBinding -Name "*" -ComponentID ms_tcpip6, ms_msclient, ms_server, ms_rspndr, ms_lltdio, ms_implat, ms_lldp" >nul 2>&1

echo]
echo Disable LMHOSTS
Reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" /v "EnableLMHOSTS" /t REG_DWORD /d "0" /f > nul

if %settweaks%==1 (exit /b)
if %ERRORLEVEL%==0 (echo %date% - %time% Network Optimized...>> C:\Windows\DuckModules\logs\userScript.log
) ELSE (echo %date% - %time% Failed to Optimize Network! >> C:\Windows\DuckModules\logs\userScript.log)
goto finish

:debugProfile
systeminfo > C:\Windows\DuckModules\logs\systemInfo.log
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
if %ERRORLEVEL%==0 echo %date% - %time% VPN Disabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% VPN Enabled...>> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Event Log disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:eventlogE
sc config EventLog start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Event Log enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish
:scheduleD
echo Disabling Task Scheduler will break some features:
echo - MSI Afterburner startup/Updates
echo - UWP Typing (e.g. Search Bar)
sc config Schedule start=disabled
if %ERRORLEVEL%==0 echo %date% - %time% Task Scheduler disabled...>> C:\Windows\DuckModules\logs\userScript.log
echo If you experience random issues, please enable Task Scheduler again.
goto finish
:scheduleE
sc config Schedule start=auto
if %ERRORLEVEL%==0 echo %date% - %time% Task Scheduler enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:scoop
echo Installing scoop...
set /P c="Review Install script before executing? [Y/N]: "
if /I "%c%" EQU "Y" curl "https://raw.githubusercontent.com/lukesampson/scoop/master/bin/install.ps1" -o C:\Windows\DuckModules\install.ps1 && notepad C:\Windows\DuckModules\install.ps1
if /I "%c%" EQU "N" curl "https://raw.githubusercontent.com/lukesampson/scoop/master/bin/install.ps1" -o C:\Windows\DuckModules\install.ps1
powershell -NoProfile Set-ExecutionPolicy RemoteSigned -scope CurrentUser
powershell -NoProfile C:\Windows\DuckModules\install.ps1
echo Refreshing environment for Scoop...
call C:\Windows\DuckModules\refreshenv.cmd
echo.
echo Installing git...
:: Scoop isn't very nice with batch scripts, and will break the whole script if a warning or error shows..
cmd /c scoop install git -g
call C:\Windows\DuckModules\refreshenv.cmd
echo .
echo Adding extras bucket...
cmd /c scoop bucket add extras
goto finish

:browser
for /f "tokens=1 delims=;" %%i in ('C:\Windows\DuckModules\Apps\multichoice.exe "Browser" "Pick a browser" "Ungoogled-Chromium;Firefox;Brave;GoogleChrome"') do (
	set spacedelimited=%%i
	set spacedelimited=!spacedelimited:;= !
	cmd /c scoop install !spacedelimited! -g
)
::if "%filtered%" == "" echo You need to install a browser! You will need it later on. && pause && goto browser
:: must launch in separate process, scoop seems to exit the whole script if not
goto finish

:altSoftware
:: Findstr for 7zip-zstd, add versions bucket if errlvl 0
for /f "tokens=*" %%i in ('C:\Windows\DuckModules\Apps\multichoice.exe "Common Software" "Install Common Software" "discord;bleachbit;notepadplusplus;msiafterburner;rtss;thunderbird;foobar2000;irfanview;git;mpv;vlc;vscode;putty;ditto"') do (
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
call :setVer
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
echo %date% - %time% Default Windows Update policies applied >> C:\Windows\DuckModules\logs\userScript.log
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
echo %date% - %time% Static IP set! (%LocalIP%)(%DHCPGateway%)(%DHCPSubnetMask%) >> C:\Windows\DuckModules\logs\userScript.log
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
if %ERRORLEVEL%==0 echo %date% - %time% Display Scaling Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:DSCPauto
for /f "tokens=* delims=\" %%i in ('C:\Windows\DuckModules\Apps\filepicker.exe exe') do (
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
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Dynamic P-States Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:revertNVPState
for /F "tokens=*" %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /t REG_SZ /s /e /f "NVIDIA"^| findstr "HK"') do (
    reg delete "%%i" /v "DisableDynamicPstate" /f
)
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Dynamic P-States Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finish

:nvcontainerD
:: Check if the service exists
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
    pause
    exit /B
)
echo Disabling the NVIDIA Display Container LS service will stop the NVIDIA Control Panel from working.
echo You can enable the NVIDIA Control Panel by running the other version of this script, which enables the service.
echo Read README.txt for more info.
pause
reg add "HKLM\System\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem" /v "Start" /t REG_DWORD /d "4" /f
sc stop NVDisplay.ContainerLocalSystem
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerE
:: Check if the service exists
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
    pause
    exit /B
)
reg add "HKLM\System\CurrentControlSet\Services\NVDisplay.ContainerLocalSystem" /v "Start" /t REG_DWORD /d "2" /f
sc start NVDisplay.ContainerLocalSystem
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerCME
:: cm = context menu
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
    pause
    exit /B
)
echo Explorer will be restarted to ensure that the context menu works.
pause
:: get icon exe
:: different for older/newer drivers
if not exist "C:\Program Files\NVIDIA Corporation\Display.NvContainer\" (
	cd /d C:\Windows\System32\DriverStore\FileRepository\nv_dispig.inf_?????_*\Display.NvContainer\
) else (
	cd /d C:\Program Files\NVIDIA Corporation\Display.NvContainer\
)
copy "NVDisplay.Container.exe" "C:\Windows\System32\NvidiaIcon.exe" /B /Y
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "Icon" /t REG_SZ /d "C:\Windows\System32\NvidiaIcon.exe,0" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "MUIVerb" /t REG_SZ /d "NVIDIA Container" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "Position" /t REG_SZ /d "Bottom" /f
reg add "HKCR\DesktopBackground\Shell\NVIDIAContainer" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001" /v "MUIVerb" /t REG_SZ /d "Enable NVIDIA Container" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer001\command" /ve /t REG_SZ /d "C:\Windows\DuckModules\Apps\nsudo.exe -U:T -P:E -UseCurrentConsole -Wait C:\Windows\DuckModules\duck-config.cmd /nvcontainerE" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002" /v "HasLUAShield" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002" /v "MUIVerb" /t REG_SZ /d "Disable NVIDIA Container" /f
reg add "HKCR\DesktopBackground\shell\NVIDIAContainer\shell\NVIDIAContainer002\command" /ve /t REG_SZ /d "C:\Windows\DuckModules\Apps\nsudo.exe -U:T -P:E -UseCurrentConsole -Wait C:\Windows\DuckModules\duck-config.cmd /nvcontainerD" /f
taskkill /f /im explorer.exe
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
nsudo.exe -U:E -P:E -Wait explorer.exe
if %errorlevel%==0 echo %date% - %time% NVIDIA Display Container LS Context Menu Enabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:nvcontainerCMD
:: cm = context menu
sc query NVDisplay.ContainerLocalSystem >nul 2>&1
if %errorlevel%==1 (
    echo The NVIDIA Display Container LS service does not exist, you can not continue.
    pause
    exit /B
)
reg query "HKCR\DesktopBackground\shell\NVIDIAContainer" >nul 2>&1
if %errorlevel%==1 (
    echo The context menu does not exist, you can not continue.
    pause
    exit /B
)
echo Explorer will be restarted to ensure that the context menu is gone.
pause
reg delete "HKCR\DesktopBackground\Shell\NVIDIAContainer" /f
:: delete icon exe
erase /F /Q "C:\Windows\System32\NvidiaIcon.exe"
taskkill /f /im explorer.exe
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
nsudo.exe -U:E -P:E -Wait explorer.exe
if %ERRORLEVEL%==0 echo %date% - %time% NVIDIA Display Container LS Context Menu Disabled...>> C:\Windows\DuckModules\logs\userScript.log
goto finishNRB

:networksharingE
echo Enabling Workstation as a dependency...
call :workstationE "int"
sc config eventlog start=auto
echo %date% - %time% EventLog enabled as Network Sharing dependency...>> C:\Windows\DuckModules\logs\userscript.log
reg add "HKLM\System\CurrentControlSet\Services\NlaSvc" /v "Start" /t REG_DWORD /d "2" /f
reg add "HKLM\System\CurrentControlSet\Services\lmhosts" /v "Start" /t REG_DWORD /d "3" /f
reg add "HKLM\System\CurrentControlSet\Services\netman" /v "Start" /t REG_DWORD /d "3" /f
echo %date% - %time% Network Sharing enabled...>> C:\Windows\DuckModules\logs\userscript.log
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
PowerShell -ExecutionPolicy Unrestricted -Command "$command = 'reg add "^""HKLM\SOFTWARE\Microsoft\Windows Defender\UX Configuration"^"" /v "^""DisablePrivacyMode"^"" /t REG_DWORD /d "^""1"^"" /f'; $trustedInstallerSid = [System.Security.Principal.SecurityIdentifier]::new('S-1-5-80-956008885-3418522649-1831038044-1853292631-2271478464'); $trustedInstallerName = $trustedInstallerSid.Translate([System.Security.Principal.NTAccount]); $streamOutFile = New-TemporaryFile; $batchFile = New-TemporaryFile; try {; $batchFile = Rename-Item $batchFile "^""$($batchFile.BaseName).bat"^"" -PassThru; "^""@echo off`r`n$command`r`nexit 0"^"" | Out-File $batchFile -Encoding ASCII; $taskName = 'privacy.sexy invoke'; schtasks.exe /delete /tn "^""$taskName"^"" /f 2>&1 | Out-Null <# Clean if something went wrong before, suppress any output #>; $taskAction = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument "^""cmd /c `"^""$batchFile`"^"" > $streamOutFile 2>&1"^""; $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries; Register-ScheduledTask -TaskName $taskName -Action $taskAction -Settings $settings -Force -ErrorAction Stop | Out-Null; try {; ($scheduleService = New-Object -ComObject Schedule.Service).Connect(); $scheduleService.GetFolder('\').GetTask($taskName).RunEx($null, 0, 0, $trustedInstallerName) | Out-Null; $timeOutLimit = (Get-Date).AddMinutes(5); Write-Host "^""Running as $trustedInstallerName"^""; while((Get-ScheduledTaskInfo $taskName).LastTaskResult -eq 267009) {; Start-Sleep -Milliseconds 200; if((Get-Date) -gt $timeOutLimit) {; Write-Warning "^""Skipping results, it took so long to execute script."^""; break;; }; }; if (($result = (Get-ScheduledTaskInfo $taskName).LastTaskResult) -ne 0) {; Write-Error "^""Failed to execute with exit code: $result."^""; }; } finally {; schtasks.exe /delete /tn "^""$taskName"^"" /f | Out-Null <# Outputs only errors #>; }; Get-Content $streamOutFile; } finally {; Remove-Item $streamOutFile, $batchFile; }"

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

REM :removeCapability
REM :: %delCapabilty% /debug (capability name)
REM :: %delPackage% /debug (package name, FOD)
REM :: %disableFeature% /debug (feature name)

REM :: Example: %delCapabilty% XPS.Viewer
REM :: If there are multiple results for one input, then it will only remove the first one in the list
REM :: You should be as specific as possible
REM :: Credit to Mathieu#4291 for fixing up my messy and broken code

REM for %%A in (_errorlevel fullname debug feature package) do (
    REM if defined %%A (
        REM set %%A=
    REM )
REM )

REM set commandget=/Get-Capabilities
REM set commandremove=/Remove-Capability
REM set commandname=/CapabilityName
REM set capability=true
REM set find=Installed

REM :removeCapability1
REM if not "%~1"=="" (
	REM if "%~1"=="/debug" (
		REM set debug=true
	REM )
	REM if "%~1"=="/feature" (
		REM set capability=false
		REM set feature=true
		REM set commandget=/Get-Features
		REM set commandremove=/Disable-Feature
		REM set commandname=/FeatureName
		REM set find=Enabled
	REM )
	REM if "%~1"=="/package" (
		REM set capability=false
		REM set package=true
		REM set commandget=/Get-Packages
		REM set commandremove=/Remove-Package
		REM set commandname=/PackageName
	REM )
	REM shift
	REM goto removeCapability1
REM )

REM if %debug%==true (echo Input: %*)
REM for %%A in (_errorlevel fullname) do (
    REM if defined %%A (
        REM set %%A=
    REM )
REM )
REM for /f %%A in ('2^>nul DISM.exe /Online %commandget% /Format:Table ^| find ^"%find%^" ^| find ^"%1^" ^& call echo %%^^errorlevel%%') do (
    REM if defined _errorlevel (
        REM set "fullname=!_errorlevel!"
    REM )
    REM set "_errorlevel=%%A"
REM )
REM :: Should output the error level
REM if %debug%==true echo Errorlevel: %_errorlevel%
REM if not %_errorlevel%==0 (
    REM if %fullname%==true (echo Capabilities matching %1 were not found or there was an error listing installed capabilities && exit /b 1)
	REM if %feature%==true (echo Features matching %1 were not found or there was an error listing installed features && exit /b 1)
	REM if %package%==true (echo Packages matching %1 were not found or there was an error listing installed packages && exit /b 1)
REM )
REM echo Removing or disabling %fullname%
REM >nul 2>&1 DISM /Online %commandremove% %commandname%:%fullname% || (
    REM if !errorlevel!==1 (
        REM if %capability%==true (echo Error removing the %fullname% capability && exit /b 1)
		REM if %feature%==true (echo Error disabling the %fullname% feature && exit /b 1)
		REM if %package%==true (echo Error removing the %fullname% package && exit /b 1)
    REM )
REM )
REM exit /b

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

:setVer
:: Checks the current OS (10/11) and sets it as the version
for /f "tokens=6 delims=[.] " %%a in ('ver') do (set "win_version=%%a")
if %win_version% lss 22000 (set os=Windows 10) else (set os=Windows 11)
for /f "tokens=3" %%a in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "DisplayVersion"') do (set releaseid=%%a)
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
