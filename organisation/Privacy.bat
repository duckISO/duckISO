echo]
echo Search settings - (disable Cortana and web search)
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "ConnectedSearchUseWeb" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Windows Search" /v "CortanaConsent" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable speech model updates
reg add "HKLM\Software\Policies\Microsoft\Speech" /v "AllowSpeechModelUpdate" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Microsoft\Speech_OneCore\Preferences" /v "ModelDownloadAllowed" /t REG_DWORD /d "0" /f > nul

echo]
echo Pause Maps updates/downloads
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AutoDownloadAndUpdateMapData" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\Maps" /v "AllowUntriggeredNetworkTrafficOnSettingsPage" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable CEIP (Customer Experience Improvement Program)
%currentuser% reg add "HKCU\Software\Policies\Microsoft\Messenger\Client" /v "CEIP" /t REG_DWORD /d "2" /f > nul
reg add "HKLM\Software\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable Windows Media Player DRM online access - just uninstall it
reg add "HKLM\Software\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d "1" /f > nul

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
echo Disable Windows Error Reporting
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t "REG_DWORD" /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "DontSendAdditionalData" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting" /v "LoggingDisabled" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultOverrideBehavior" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Microsoft\Windows\Windows Error Reporting\Consent" /v "DefaultConsent" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable general data collection
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
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\DeviceCensus.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\rundll32.exe" /f > nul

echo]
echo Disable CompatTelRunner.exe (Microsoft Compatibility Appraiser) process
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\CompatTelRunner.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\rundll32.exe" /f > nul

echo]
echo Do not send Windows Media Player statistics
%currentuser% reg add "HKCU\SOFTWARE\Microsoft\MediaPlayer\Preferences" /v "UsageTracking" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable metadata retrieval - Windows Media Player (please just uninstall it)
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventCDDVDMetadataRetrieval" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventMusicFileMetadataRetrieval" /t REG_DWORD /d 1 /f > nul
%currentuser% reg add "HKCU\Software\Policies\Microsoft\WindowsMediaPlayer" /v "PreventRadioPresetsRetrieval" /t REG_DWORD /d 1 /f > nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\WMDRM" /v "DisableOnline" /t REG_DWORD /d 1 /f > nul

echo]
echo Prevent downloading a list of providers for wizards
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoWebServices" /t REG_DWORD /d 1 /f > nul

echo]
echo Disable Sleep Study
reg add "HKLM\System\CurrentControlSet\Control\Session Manager\Power" /v "SleepStudyDisabled" /t REG_DWORD /d "1" /f > nul

echo]
echo Advertising Info
reg add "HKLM\Software\Policies\Microsoft\Windows\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d "1" /f > nul
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Opt-out of sending KMS client activation data to Microsoft automatically. 
echo Enabling this setting prevents this computer from sending data to Microsoft regarding its activation state.
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t REG_DWORD /d "1" /f > nul

echo]
echo Disable Windows Settings sync
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
echo Location Tracking
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "AllowFindMyDevice" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\FindMyDevice" /v "LocationSyncEnabled" /t REG_DWORD /d "0" /f > nul

echo]
echo Do not show recently used files in Quick Access
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t REG_DWORD /d "0" /f > nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f > nul
if not %PROCESSOR_ARCHITECTURE%==x86 (
    reg delete "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\HomeFolderDesktop\NameSpace\DelegateFolders\{3134ef9c-6b18-4996-ad04-ed5912e00eb5}" /f > nul
)

echo]
echo Disable shared experiences
reg add "HKLM\Software\Policies\Microsoft\Windows\System" /v "EnableCdp" /t REG_DWORD /d "0" /f > nul

echo]
echo Clear main telemetry file (if it exists)
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
echo Firewall rules (blocking apps that shouldn't have internet access)
netsh Advfirewall set allprofiles state on > nul
%fireBlockExe% "calc.exe" "%WinDir%\System32\calc.exe"
%fireBlockExe% "certutil.exe" "%WinDir%\System32\certutil.exe"
%fireBlockExe% "cmstp.exe" "%WinDir%\System32\cmstp.exe"
%fireBlockExe% "cscript.exe" "%WinDir%\System32\cscript.exe"
%fireBlockExe% "esentutl.exe" "%WinDir%\System32\esentutl.exe"
%fireBlockExe% "expand.exe" "%WinDir%\System32\expand.exe"
%fireBlockExe% "extrac32.exe" "%WinDir%\System32\extrac32.exe"
%fireBlockExe% "findstr.exe" "%WinDir%\System32\findstr.exe"
%fireBlockExe% "hh.exe" "%WinDir%\System32\hh.exe"
%fireBlockExe% "makecab.exe" "%WinDir%\System32\makecab.exe"
%fireBlockExe% "mshta.exe" "%WinDir%\System32\mshta.exe"
%fireBlockExe% "msiexe"c.exe "%WinDir%\System32\msiexec.exe"
%fireBlockExe% "nltest.exe" "%WinDir%\System32\nltest.exe"
%fireBlockExe% "Notepad.exe" "%WinDir%\System32\notepad.exe"
%fireBlockExe% "pcalua.exe" "%WinDir%\System32\pcalua.exe"
%fireBlockExe% "print.exe" "%WinDir%\System32\print.exe"
%fireBlockExe% "regsvr32.exe" "%WinDir%\System32\regsvr32.exe"
%fireBlockExe% "replace.exe" "%WinDir%\System32\replace.exe"
%fireBlockExe% "rundll32.exe" "%WinDir%\System32\rundll32.exe"
%fireBlockExe% "runscripthelper.exe" "%WinDir%\System32\runscripthelper.exe"
%fireBlockExe% "scriptrunner.exe" "%WinDir%\System32\scriptrunner.exe"
%fireBlockExe% "SyncAppvPublishingServer.exe" "%WinDir%\System32\SyncAppvPublishingServer.exe"
%fireBlockExe% "wmic.exe" "%WinDir%\System32\wbem\wmic.exe"
%fireBlockExe% "wscript.exe" "%WinDir%\System32\wscript.exe"
%fireBlockExe% "regasm.exe" "%WinDir%\System32\regasm.exe"
%fireBlockExe% "odbcconf.exe" "%WinDir%\System32\odbcconf.exe"

:: SysWOW64
%fireBlockExe% "regasm.exe" "%WinDir%\SysWOW64\regasm.exe"
%fireBlockExe% "odbcconf.exe" "%WinDir%\SysWOW64\odbcconf.exe"
%fireBlockExe% "calc.exe" "%WinDir%\SysWOW64\calc.exe"
%fireBlockExe% "certutil.exe" "%WinDir%\SysWOW64\certutil.exe"
%fireBlockExe% "cmstp.exe" "%WinDir%\SysWOW64\cmstp.exe"
%fireBlockExe% "cscript.exe" "%WinDir%\SysWOW64\cscript.exe"
%fireBlockExe% "esentutl.exe" "%WinDir%\SysWOW64\esentutl.exe"
%fireBlockExe% "expand.exe" "%WinDir%\SysWOW64\expand.exe"
%fireBlockExe% "extrac32.exe" "%WinDir%\SysWOW64\extrac32.exe"
%fireBlockExe% "findstr.exe" "%WinDir%\SysWOW64\findstr.exe"
%fireBlockExe% "hh.exe" "%WinDir%\SysWOW64\hh.exe"
%fireBlockExe% "makecab.exe" "%WinDir%\SysWOW64\makecab.exe"
%fireBlockExe% "mshta.exe" "%WinDir%\SysWOW64\mshta.exe"
%fireBlockExe% "msiexe"c.exe "%WinDir%\SysWOW64\msiexec.exe"
%fireBlockExe% "nltest.exe" "%WinDir%\SysWOW64\nltest.exe"
%fireBlockExe% "Notepad.exe" "%WinDir%\SysWOW64\notepad.exe"
%fireBlockExe% "pcalua.exe" "%WinDir%\SysWOW64\pcalua.exe"
%fireBlockExe% "print.exe" "%WinDir%\SysWOW64\print.exe"
%fireBlockExe% "regsvr32.exe" "%WinDir%\SysWOW64\regsvr32.exe"
%fireBlockExe% "replace.exe" "%WinDir%\SysWOW64\replace.exe"
%fireBlockExe% "rpcping.exe" "%WinDir%\SysWOW64\rpcping.exe"
%fireBlockExe% "rundll32.exe" "%WinDir%\SysWOW64\rundll32.exe"
%fireBlockExe% "runscripthelper.exe" "%WinDir%\SysWOW64\runscripthelper.exe"
%fireBlockExe% "scriptrunner.exe" "%WinDir%\SysWOW64\scriptrunner.exe"
%fireBlockExe% "SyncAppvPublishingServer.exe" "%WinDir%\SysWOW64\SyncAppvPublishingServer.exe"
%fireBlockExe% "wmic.exe" "%WinDir%\System32\wbem\wmic.exe"
%fireBlockExe% "wscript.exe" "%WinDir%\SysWOW64\wscript.exe"

echo]
echo Disable modern standby
:: https://winaero.com/how-to-disable-modern-standby-in-windows-11-and-windows-10
reg add "HKLM\System\CurrentControlSet\Control\Power" /v "PlatformAoAcOverride" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable jump lists
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f > nul

echo]
echo Decrease jump list size to 0
%currentuser% reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "JumpListItems_Maximum" /t REG_DWORD /d "0" /f > nul

echo]
echo Disable search box suggestions/history
%currentuser% reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "DisableSearchBoxSuggestions" /t REG_DWORD /d "1" /f > nul

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

echo]
echo Application compatability configuration
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "AllowTelemetry" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisableEngine" /t REG_DWORD /d "1" /f > nul
reg add "HKLM\Software\Policies\Microsoft\Windows\AppCompat" /v "DisablePCA" /t REG_DWORD /d "1" /f > nul