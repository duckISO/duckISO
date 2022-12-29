echo]
echo Disabling Offline Files...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\NetCache" /v "Enabled" /t REG_DWORD /d "0" /f > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\mobsync.exe" /v "Debugger" /t REG_SZ /d "%windir%\System32\rundll32.exe" /f > nul
