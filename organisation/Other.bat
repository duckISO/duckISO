echo]
echo Fix language packs...
:: https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/language-packs-known-issue
schtasks /Change /Disable /TN "\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation" >nul 2>nul
reg add "HKLM\Software\Policies\Microsoft\Control Panel\International" /v "BlockCleanupOfUnusedPreinstalledLangPacks" /t REG_DWORD /d "1" /f > nul

if %postinstall%==1 (
	echo Fix duplicate Windows Server Update Client IDs ^(SusClientID^)
	sc stop wuauserv >nul 2>nul
	reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientIdValidation" /f > nul
	reg add "HKLM\Software\Microsoft\Windows\CurrentVersion\WindowsUpdate" /v "SusClientId" /t REG_SZ /d "00000000-0000-0000-0000-000000000000" /f > nul
)

echo]
echo Disabling hibernation...
powercfg -h off > nul

echo]
echo Wallpaper
%currentuser% reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d "100" /f > nul
if %postinstall%==1 (
	%currentuser% reg add "HKCU\Control Panel\desktop" /v "Wallpaper" /t REG_SZ /d "" /f
	%currentuser% reg add "HKCU\Control Panel\Desktop" /v "Wallpaper" /t REG_SZ /d "C:\Windows\DuckModules\Other\Wallpaper.png" /f 
	%currentuser% RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters 
) > nul

echo]
echo %c_yellow%OTHER:%c_reset% Fix explorer white-bar bug...
%currentuser% cmd /c "start C:\Windows\explorer.exe"
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
taskkill /f /im explorer.exe >nul 2>&1
echo Waiting 3 seconds...
timeout /t 3 /nobreak > nul
%currentuser% cmd /c "start C:\Windows\explorer.exe"