echo]
echo Add '.reg' to new file menu
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "ItemName" /t REG_EXPAND_SZ /d "@C:\Windows\regedit.exe,-309" /f > nul
reg add "HKLM\Software\Classes\.reg\ShellNew" /v "NullFile" /t REG_SZ /d "" /f > nul

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

