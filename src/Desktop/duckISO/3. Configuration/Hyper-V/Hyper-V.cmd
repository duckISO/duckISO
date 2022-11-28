@echo off
setlocal ENABLEEXTENSIONS
setlocal DISABLEDELAYEDEXPANSION

fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select 'Run as administrator'.
        pause & exit 1
    )
    exit 0
)

:: https://learn.microsoft.com/en-us/windows/security/identity-protection/credential-guard/credential-guard-manage
:: https://sites.google.com/view/melodystweaks/basictweaks
:: https://learn.microsoft.com/en-us/windows/security/threat-protection/device-guard/enable-virtualization-based-protection-of-code-integrity

echo What would you like to do?
echo [1] Fully disable Hyper-V (default)
echo [2] Set to Windows default
echo]
choice /c 12 /n /m "Type 1 or 2: "
if %errorlevel%==1 (
	goto disable
) else (
	goto enable
)

:disable
echo]
echo Boot configuration
bcdedit /set hypervisorlaunchtype off > nul
if not %errorlevel%==0 (echo The command 'bcdedit /set hypervisorlaunchtype off' failed! This is an issue, as it actually disables Hyper-V.)
:: Not properly documented?
bcdedit /set vm no > nul
if not %errorlevel%==0 (echo The command 'bcdedit /set vm no' failed! As a note, it's mostly undocumented.)
:: Disable Virtual Secure Mode
bcdedit /set vmslaunchtype Off > nul
if not %errorlevel%==0 (
	echo The command 'bcdedit /set vmslaunchtype Off' failed! This disables Virtual Secure Mode.
	echo The value may just not exist as well, so don't worry much.
)
bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul
if not %errorlevel%==0 (echo The command 'bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS' failed! This disables Virtualization Based Security.)

echo]
echo Disabling Hyper-V with DISM...
dism /online /disable-feature:Microsoft-Hyper-V-All /quiet /norestart
if not %errorlevel%==3010 (
	echo]
	echo DISM command may have failed to enable Hyper-V.
	echo If there's no errors above, it's probably already disabled.
	echo]
)

echo]
echo Applying registry changes...
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Disabling drivers...
sc config hvcrash start=disabled > nul
sc config hvservice start=disabled > nul
sc config vhdparser start=disabled > nul
sc config vkrnlintvsc start=disabled > nul
sc config vkrnlintvsp start=disabled > nul
sc config vmbus start=disabled > nul
sc config Vid start=disabled > nul
sc config bttflt start=disabled > nul
sc config gencounter start=disabled > nul
sc config hvsocketcontrol start=disabled > nul
sc config passthruparser start=disabled > nul
sc config pvhdparser start=disabled > nul
sc config spaceparser start=disabled > nul
sc config storflt start=disabled > nul
sc config vmgid start=disabled > nul
sc config vmbusr start=disabled > nul
sc config vpci start=disabled > nul

echo]
echo Disabling services...
sc config gcs start=disabled > nul
sc config hvhost start=disabled > nul
sc config vmcompute start=disabled > nul
sc config vmicguestinterface start=disabled > nul
sc config vmicheartbeat start=disabled > nul
sc config vmickvpexchange start=disabled > nul
sc config vmicrdv start=disabled > nul
sc config vmicshutdown start=disabled > nul
sc config vmictimesync start=disabled > nul
sc config vmicvmsession start=disabled > nul
sc config vmicvss start=disabled > nul

echo]
echo Disabling devices...
devmanview /disable "Microsoft Hyper-V NT Kernel Integration VSP"
devmanview /disable "Microsoft Hyper-V PCI Server"
devmanview /disable "Microsoft Hyper-V Virtual Disk Server"
devmanview /disable "Microsoft Hyper-V Virtual Machine Bus Provider"
devmanview /disable "Microsoft Hyper-V Virtualization Infrastructure Driver"
goto success

:enable
echo]
echo Boot configuration
bcdedit /set hypervisorlaunchtype auto > nul
if not %errorlevel%==0 (echo The command 'bcdedit /set hypervisorlaunchtype auto' failed! This is an issue, as it actually enables Hyper-V.)
:: Not properly documented? Found from Melody's tweaks, related to Hyper-V
bcdedit /deletevalue vm > nul
if not %errorlevel%==0 (echo The command 'bcdedit /deletevalue vm' failed! As a note, it's mostly undocumented.)
if %vbs-cg%==false (
	bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS > nul || (
		echo The command 'bcdedit /set loadoptions DISABLE-LSA-ISO,DISABLE-VBS' failed! This disables Virtualization Based Security.
	)
	bcdedit /set vsmlaunchtype Off > nul || (
		echo The command 'bcdedit /set vmslaunchtype Off' failed! This disables Virtual Secure Mode.
		echo The value may just not exist as well, so don't worry much.
	)
) else (
	bcdedit /deletevalue loadoptions > nul || (
		echo The command 'bcdedit /deletevalue loadoptions' failed! This sets Virtualization Based Security to the default, which is unblocked.
	)
	bcdedit /set vsmlaunchtype Auto > nul || (
		echo The command 'bcdedit /set vsmlaunchtype Auto' failed! This unblocks Virtual Secure Mode.
	)
)

echo]
echo Enabling Hyper-V with DISM...
dism /online /enable-feature:Microsoft-Hyper-V-All /quiet /norestart
if not %errorlevel%==3010 (
	echo]
	echo DISM command may have failed to enable Hyper-V.
	echo If there's no errors above, it's probably already enabled.
	echo]
)

echo]
echo Applying registry changes...
:: https://admx.help/?Category=Windows_10_2016&Policy=Microsoft.Windows.DeviceGuard::VirtualizationBasedSecuritye
if %vbs-cg%==false (
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "EnableVirtualizationBasedSecurity" /d "0" /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "RequirePlatformSecurityFeatures" /d "1" /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HypervisorEnforcedCodeIntegrity" /d "0" /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "HVCIMATRequired" /d "0" /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "LsaCfgFlags" /d "0" /f > nul
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /t REG_DWORD /v "ConfigureSystemGuardLaunch" /d "0" /f > nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "0" /f > nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /t REG_DWORD /d "0" /f > nul
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /t REG_DWORD /d "0" /f > nul
) else (
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "EnableVirtualizationBasedSecurity" /f > nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "RequirePlatformSecurityFeatures" /f > nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HypervisorEnforcedCodeIntegrity" /f > nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "HVCIMATRequired" /f > nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "LsaCfgFlags" /f > nul
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard" /v "ConfigureSystemGuardLaunch" /f > nul
	:: Found this to be the default
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard" /v "RequireMicrosoftSignedBootChain" /t REG_DWORD /d "1" /f > nul
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "WasEnabledBy" /f > nul
	reg delete "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v "Enabled" /f > nul
)

echo]
echo Enabling drivers...
:: Default for hvcrash is disabled
sc config hvcrash start=disabled > nul
sc config hvservice start=manual > nul
sc config vhdparser start=manual > nul
sc config vmbus start=boot > nul
sc config Vid start=system > nul
sc config bttflt start=boot > nul
sc config gencounter start=manual > nul
sc config hvsocketcontrol start=manual > nul
sc config passthruparser start=manual > nul
sc config pvhdparser start=manual > nul
sc config spaceparser start=manual > nul
sc config storflt start=boot > nul
sc config vmgid start=manual > nul
sc config vmbusr start=manual > nul
sc config vpci start=boot > nul

echo]
echo Enabling services...
sc config gcs start=manual > nul
sc config hvhost start=manual > nul
sc config vmcompute start=manual > nul
sc config vmicguestinterface start=manual > nul
sc config vmicheartbeat start=manual > nul
sc config vmickvpexchange start=manual > nul
sc config vmicrdv start=manual > nul
sc config vmicshutdown start=manual > nul
sc config vmictimesync start=manual > nul
sc config vmicvmsession start=manual > nul
sc config vmicvss start=manual > nul

echo]
echo Enabling devices...
devmanview /enable "Microsoft Hyper-V NT Kernel Integration VSP"
devmanview /enable "Microsoft Hyper-V PCI Server"
devmanview /enable "Microsoft Hyper-V Virtual Disk Server"
devmanview /enable "Microsoft Hyper-V Virtual Machine Bus Provider"
devmanview /enable "Microsoft Hyper-V Virtualization Infrastructure Driver"
goto success

:success
echo]
echo Finished, please restart to see the changes.
pause
exit /b 0