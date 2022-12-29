echo]
echo MSI mode
echo]
echo Enable MSI mode for USB controllers...
:: second command for each device deletes device priorty, setting it to undefined
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg add "HKLM\System\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties" /v "MSISupported" /t REG_DWORD /d "1" /f
for /f %%i in ('wmic path Win32_USBController get PNPDeviceID^| findstr /L "PCI\VEN_"') do reg delete "HKLM\SYSTEM\CurrentControlSet\Enum\%%i\Device Parameters\Interrupt Management\Affinity Policy" /v "DevicePriority" /f >nul 2>nul

echo Enable MSI mode on GPU, could be reset by installing a GPU driver (enable the tweak in NVCleanstall)...
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
echo Disable search indexing (use Everything by voidtools instead)
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "WholeFileSystem" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Search\Preferences" /v "SystemFolders" /t REG_DWORD /d "0" /f > nul

echo]
echo Disabling devices...
devmanview /disable "System Speaker"
devmanview /disable "System Timer"
devmanview /disable "UMBus Root Bus Enumerator"
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

:: Enable Hardware Accelerated GPU Scheduling (HAGS)
reg add "HKLM\System\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d "2" /f

echo]
echo Data Queue Sizes
reg add "HKLM\System\CurrentControlSet\Services\mouclass\Parameters" /v "MouseDataQueueSize" /t REG_DWORD /d "50" /f > nul
reg add "HKLM\System\CurrentControlSet\Services\kbdclass\Parameters" /v "KeyboardDataQueueSize" /t REG_DWORD /d "50" /f > nul

:: Broken on Win 11, default on 10
if "%os%"=="Windows 10" (
	echo Old window switcher (alt + tab)
	%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "AltTabSettings" /t REG_DWORD /d "1" /f
)

echo]
echo Disabling memory compression...
powershell -NoProfile -Command "Disable-MMAgent -mc" > nul

echo]
echo Disable ReadyBoost ^& get rid of tab
reg delete "HKCR\Drive\shellex\PropertySheetHandlers\{55B3A0BD-4D28-42fe-8CFB-FA3EDFF969B8}" /f >nul 2>nul
:: ReadyBoost and memory compression
reg add "HKLM\SYSTEM\ControlSet001\Control\Class\{71a27cdd-812a-11d0-bec7-08002be2092f}" /v "LowerFilters" /t REG_MULTI_SZ /d "fvevol\0iorate" /f > nul
%svc% rdyboost 4
%svc% SysMain 4
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\ControlSet001\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnableSuperfetch" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "GroupPolicyDisallowCaches" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\EMDMgmt" /v "AllowNewCachesByDefault" /t REG_DWORD /d "0" /f > nul

:: --------------------------------------------------- ::
echo]
echo %c_underline%%c_cyan%NTFS tweaks%c_reset%
:: --------------------------------------------------- ::

:: https://notes.ponderworthy.com/fsutil-tweaks-for-ntfs-performance-and-reliability
echo Disable last access info on directories
fsutil behavior set disableLastAccess 1 > nul
:: https://ttcshelbyville.wordpress.com/2018/12/02/should-you-disable-8dot3-for-performance-and-security/
echo Disable 8dot3 (short names)
fsutil behavior set disable8dot3 1 > nul
echo Increase the RAM cache devoted to NTFS
fsutil behavior set memoryusage 2 > nul

:: --------------------------------------------------- ::

:: --------------------------------------------------- ::
echo]
echo %c_underline%%c_cyan%Mitigations%c_reset%
:: --------------------------------------------------- ::

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

echo Disable filesystem mitigations - performance
reg add "HKLM\System\CurrentControlSet\Control\Session Manager" /v "ProtectionMode" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Fault Tolerant Heap (FTH)
:: https://docs.microsoft.com/en-us/windows/win32/win7appqual/fault-tolerant-heap
:: Doc listed as only affected in Windows 7, is also in 7+
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
echo Disallow Background Apps
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d "2" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BackgroundAppGlobalToggle" /t REG_DWORD /d "0" /f > nul

echo]
echo Set Win32PrioritySeparation 0x2A
:: https://docs.google.com/spreadsheets/d/1ZWQFycOWdODkUOuYZCxm5lTp08V2m7gjZQSCjywAsl8/edit#gid=762933934
:: 0x2A-Short-Fixed-High foreground boost
reg add "HKLM\System\CurrentControlSet\Control\PriorityControl" /v "Win32PrioritySeparation" /t REG_DWORD /d "42" /f > nul

echo]
echo DWM
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "EnableAeroPeek" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\DWM" /v "DisallowAnimations" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\Windows\DWM" /v "Composition" /t REG_DWORD /d "0" /f > nul
:: Needs testing
:: https://djdallmann.github.io/GamingPCSetup/CONTENT/RESEARCH/FINDINGS/registrykeys_dwm.txt
:: reg add "HKLM\Software\Microsoft\Windows\Dwm" /v "AnimationAttributionEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Storage Sense
reg add "HKLM\Software\Policies\Microsoft\Windows\StorageSense" /v "AllowStorageSenseGlobal" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Maintenance
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" /v "MaintenanceDisabled" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable DmaRemapping
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/pci/enabling-dma-remapping-for-device-drivers
for /f %%i in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services" /s /f DmaRemappingCompatible ^| find /i "Services\" ') do (
	reg add "%%i" /v "DmaRemappingCompatible" /t REG_DWORD /d "0" /f
)

echo]
echo Set CSRSS to high prority 
:: CSRSS is responsible for mouse input, setting to high may yield an improvement in input latency
:: Matches DWM priority
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "3" /f > nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\csrss.exe\PerfOptions" /v "IoPriority" /t REG_DWORD /d "3" /f > nul

echo]
echo Clear Windows temp files
del /f /q %localappdata%\Temp\* >nul 2>nul
rd /s /q "%WINDIR%\Temp\*" >nul 2>nul
rd /s /q "%TEMP%\*" >nul 2>nul

echo]
echo Set some system processes priority below normal
for %%i in (lsass.exe sppsvc.exe SearchIndexer.exe fontdrvhost.exe sihost.exe ctfmon.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f > nul
)
echo]
echo Set some background apps priority below normal
for %%i in (OriginWebHelperService.exe ShareX.exe EpicWebHelper.exe SocialClubHelper.exe steamwebhelper.exe) do (
  reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%i\PerfOptions" /v "CpuPriorityClass" /t REG_DWORD /d "5" /f > nul
)

:: --------------------------------------------------- ::

:: --------------------------------------------------- ::
echo]
echo %c_underline%%c_cyan%Boot Configuration%c_reset%
:: --------------------------------------------------- ::

:: https://docs.google.com/spreadsheets/d/1ZWQFycOWdODkUOuYZCxm5lTp08V2m7gjZQSCjywAsl8/edit#gid=1190036594
:: https://docs.microsoft.com/en-us/windows-hardware/drivers/devtest/bcdedit--set

echo Lowering dual boot choice time
:: No, this does NOT affect single OS boot time.
bcdedit /timeout 10 > nul

:: echo Disable synthetic timer
:: Not tested properly
:: bcdedit /set useplatformtick yes > nul

echo Disable tickless kernel (power saving)
bcdedit /set disabledynamictick Yes > nul

echo Enable Data Execution Prevention for OS components only
:: https://docs.microsoft.com/en-us/windows/win32/memory/data-execution-prevention
bcdedit /set nx Optin > nul

echo Hyper-V support is disabled by default
bcdedit /set hypervisorlaunchtype off > nul
bcdedit /set vsmlaunchtype Off > nul
:: Not properly documented
:: bcdedit /set vm No > nul
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul

echo Use legacy boot menu
bcdedit /set bootmenupolicy Legacy > nul

echo Make dual boot menu more descriptive
bcdedit /set description duckISO %os% %version% > nul

echo Lower latency - tscsyncpolicy
bcdedit /set tscsyncpolicy Enhanced > nul

echo Disable automatic repair - it doesn't do much to help and can cause issues
:: https://winaero.com/how-to-disable-automatic-repair-at-windows-10-boot/
bcdedit /set {current} bootstatuspolicy IgnoreAllFailures > nul

:: --------------------------------------------------- ::

echo]
echo Increase icon cache size
:: Can improve performance: https://winaero.com/change-icon-cache-size-windows-10/
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "Max Cached Icons" /t REG_SZ /d "8192" /f > nul

:: --------------------------------------------------- ::
echo]
echo %c_underline%%c_cyan%Disable Power Saving%c_reset%
:: --------------------------------------------------- ::

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

:: --------------------------------------------------- ::

:: --------------------------------------------------- ::
echo]
echo %c_underline%%c_cyan%Power Plan%c_reset%
:: --------------------------------------------------- ::

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

:: --------------------------------------------------- ::

:: Network tweaks
call :netDuckDefault