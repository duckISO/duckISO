@echo off
title 7-Zip configuration script

:: Get admin rights
fltmc >nul 2>&1 || (
    echo Administrator privileges are required.
    PowerShell -NonInteractive -NoProfile Start -Verb RunAs '%0' 2> nul || (
        echo Right-click on the script and select "Run as administrator".
        pause
		exit /b 0
    )
    exit /b 0
)

for %%A in (
	associations
	context
	largepages
) do (
	set %%A=false
)

:message
cls
echo This script configures 7-Zip to most people's optimal configuration.
echo[
echo What would you like to do?
echo 1) Set the minimal context menu only
echo 2) Set file assocations only
echo 3) Set large pages only
echo 4) Do everything
CHOICE /N /C:1234 /M "Please input your answer here ->"
IF %ERRORLEVEL%==1 (
	set context=true
	goto :check
) else IF %ERRORLEVEL%==2 (
	set associations=true
	goto :check
) else IF %ERRORLEVEL%==3 (
	set largepages=true
	goto :check
) else IF %ERRORLEVEL%==4 (
	set context=true
	set associations=true
	set largepages=true
	goto :check
)
goto :message

:check
:: Check if 7-Zip is installed in the normal Scoop location
if exist "C:\Program Files\7-Zip\" (
	goto :start
) else (
	echo[
	echo 7-Zip does not seem to be installed in the default location.
	echo You may have 7-Zip installed via Scoop. If so, use the other script.
	echo The script can not continue.
	pause
	exit /b
)

:start
:: Can improve performance - https://sevenzip.osdn.jp/chm/cmdline/switches/large_pages.htm
if %largepages%==true (
	reg add "HKCU\SOFTWARE\7-Zip" /v "LargePages" /t REG_DWORD /d "1" /f
)
:: Sets a more minimal context menu - https://i.imgur.com/wUdv7qQ.png
if %context%==true (
	reg add "HKCU\SOFTWARE\7-Zip\Options" /v "ContextMenu" /t REG_DWORD /d "4903" /f
)
if %associations%==true (
	goto :association
)
goto :finish

:association
:: Sets all of the file assocations in the 7-Zip FM settings for all users
:: Not really in any order
:: Reg Converter 1.2 used
reg add "HKCU\Software\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f
reg add "HKCU\Software\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f
reg add "HKCU\Software\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f
reg add "HKCU\Software\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.7z" /ve /t REG_SZ /d "7-Zip.7z" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z" /ve /t REG_SZ /d "7z Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,0" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.7z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f
reg add "HKCU\Software\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f
reg add "HKCU\Software\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f
reg add "HKCU\Software\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.zip" /ve /t REG_SZ /d "7-Zip.zip" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip" /ve /t REG_SZ /d "zip Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,1" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.zip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f
reg add "HKCU\Software\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f
reg add "HKCU\Software\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f
reg add "HKCU\Software\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.rar" /ve /t REG_SZ /d "7-Zip.rar" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar" /ve /t REG_SZ /d "rar Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,3" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f
reg add "HKCU\Software\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f
reg add "HKCU\Software\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f
reg add "HKCU\Software\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.001" /ve /t REG_SZ /d "7-Zip.001" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001" /ve /t REG_SZ /d "001 Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,9" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.001\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f
reg add "HKCU\Software\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f
reg add "HKCU\Software\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f
reg add "HKCU\Software\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.cab" /ve /t REG_SZ /d "7-Zip.cab" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab" /ve /t REG_SZ /d "cab Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,7" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cab\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f
reg add "HKCU\Software\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f
reg add "HKCU\Software\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f
reg add "HKCU\Software\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.iso" /ve /t REG_SZ /d "7-Zip.iso" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso" /ve /t REG_SZ /d "iso Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,8" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.iso\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f
reg add "HKCU\Software\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
reg add "HKCU\Software\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.xz" /ve /t REG_SZ /d "7-Zip.xz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz" /ve /t REG_SZ /d "xz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f
reg add "HKCU\Software\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
reg add "HKCU\Software\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.txz" /ve /t REG_SZ /d "7-Zip.txz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz" /ve /t REG_SZ /d "txz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,23" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.txz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f
reg add "HKCU\Software\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f
reg add "HKCU\Software\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f
reg add "HKCU\Software\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.lzma" /ve /t REG_SZ /d "7-Zip.lzma" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma" /ve /t REG_SZ /d "lzma Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,16" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzma\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f
reg add "HKCU\Software\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f
reg add "HKCU\Software\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f
reg add "HKCU\Software\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.tar" /ve /t REG_SZ /d "7-Zip.tar" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar" /ve /t REG_SZ /d "tar Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,13" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f
reg add "HKCU\Software\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f
reg add "HKCU\Software\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f
reg add "HKCU\Software\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.cpio" /ve /t REG_SZ /d "7-Zip.cpio" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio" /ve /t REG_SZ /d "cpio Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,12" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.cpio\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f
reg add "HKCU\Software\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f
reg add "HKCU\Software\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKCU\Software\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.bz2" /ve /t REG_SZ /d "7-Zip.bz2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2" /ve /t REG_SZ /d "bz2 Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f
reg add "HKCU\Software\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f
reg add "HKCU\Software\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKCU\Software\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.bzip2" /ve /t REG_SZ /d "7-Zip.bzip2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2" /ve /t REG_SZ /d "bzip2 Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.bzip2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f
reg add "HKCU\Software\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f
reg add "HKCU\Software\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKCU\Software\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.tbz2" /ve /t REG_SZ /d "7-Zip.tbz2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2" /ve /t REG_SZ /d "tbz2 Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz2\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f
reg add "HKCU\Software\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKCU\Software\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.tbz" /ve /t REG_SZ /d "7-Zip.tbz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz" /ve /t REG_SZ /d "tbz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,2" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tbz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f
reg add "HKCU\Software\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKCU\Software\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.gz" /ve /t REG_SZ /d "7-Zip.gz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz" /ve /t REG_SZ /d "gz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f
reg add "HKCU\Software\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f
reg add "HKCU\Software\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKCU\Software\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.gzip" /ve /t REG_SZ /d "7-Zip.gzip" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip" /ve /t REG_SZ /d "gzip Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.gzip\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f
reg add "HKCU\Software\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKCU\Software\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.tgz" /ve /t REG_SZ /d "7-Zip.tgz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz" /ve /t REG_SZ /d "tgz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tgz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f
reg add "HKCU\Software\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKCU\Software\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.tpz" /ve /t REG_SZ /d "7-Zip.tpz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz" /ve /t REG_SZ /d "tpz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,14" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.tpz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f
reg add "HKCU\Software\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f
reg add "HKCU\Software\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
reg add "HKCU\Software\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.z" /ve /t REG_SZ /d "7-Zip.z" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z" /ve /t REG_SZ /d "z Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.z\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f
reg add "HKCU\Software\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f
reg add "HKCU\Software\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
reg add "HKCU\Software\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.taz" /ve /t REG_SZ /d "7-Zip.taz" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz" /ve /t REG_SZ /d "taz Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,5" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.taz\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f
reg add "HKCU\Software\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f
reg add "HKCU\Software\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
reg add "HKCU\Software\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.lzh" /ve /t REG_SZ /d "7-Zip.lzh" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh" /ve /t REG_SZ /d "lzh Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lzh\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f
reg add "HKCU\Software\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f
reg add "HKCU\Software\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
reg add "HKCU\Software\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.lha" /ve /t REG_SZ /d "7-Zip.lha" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha" /ve /t REG_SZ /d "lha Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,6" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.lha\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f
reg add "HKCU\Software\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f
reg add "HKCU\Software\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f
reg add "HKCU\Software\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.rpm" /ve /t REG_SZ /d "7-Zip.rpm" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm" /ve /t REG_SZ /d "rpm Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,10" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.rpm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f
reg add "HKCU\Software\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f
reg add "HKCU\Software\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f
reg add "HKCU\Software\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.deb" /ve /t REG_SZ /d "7-Zip.deb" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb" /ve /t REG_SZ /d "deb Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,11" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.deb\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f
reg add "HKCU\Software\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f
reg add "HKCU\Software\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f
reg add "HKCU\Software\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.arj" /ve /t REG_SZ /d "7-Zip.arj" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj" /ve /t REG_SZ /d "arj Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,4" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.arj\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f
reg add "HKCU\Software\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f
reg add "HKCU\Software\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f
reg add "HKCU\Software\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.vhd" /ve /t REG_SZ /d "7-Zip.vhd" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd" /ve /t REG_SZ /d "vhd Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.vhdx" /ve /t REG_SZ /d "7-Zip.vhdx" /f
reg add "HKCU\Software\Classes\7-Zip.vhdx" /ve /t REG_SZ /d "vhdx Archive" /f
reg add "HKCU\Software\Classes\7-Zip.vhdx\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f
reg add "HKCU\Software\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.vhdx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.vhdx" /ve /t REG_SZ /d "7-Zip.vhdx" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx" /ve /t REG_SZ /d "vhdx Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,20" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.vhdx\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f
reg add "HKCU\Software\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f
reg add "HKCU\Software\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKCU\Software\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.wim" /ve /t REG_SZ /d "7-Zip.wim" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim" /ve /t REG_SZ /d "wim Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.wim\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f
reg add "HKCU\Software\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f
reg add "HKCU\Software\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKCU\Software\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.swm" /ve /t REG_SZ /d "7-Zip.swm" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm" /ve /t REG_SZ /d "swm Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.swm\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.esd" /ve /t REG_SZ /d "7-Zip.esd" /f
reg add "HKCU\Software\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f
reg add "HKCU\Software\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKCU\Software\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.esd" /ve /t REG_SZ /d "7-Zip.esd" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd" /ve /t REG_SZ /d "esd Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,15" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.esd\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f
reg add "HKCU\Software\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f
reg add "HKCU\Software\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f
reg add "HKCU\Software\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.fat" /ve /t REG_SZ /d "7-Zip.fat" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat" /ve /t REG_SZ /d "fat Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,21" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.fat\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f
reg add "HKCU\Software\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f
reg add "HKCU\Software\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f
reg add "HKCU\Software\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.ntfs" /ve /t REG_SZ /d "7-Zip.ntfs" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs" /ve /t REG_SZ /d "ntfs Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,22" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.ntfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f
reg add "HKCU\Software\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f
reg add "HKCU\Software\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f
reg add "HKCU\Software\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.dmg" /ve /t REG_SZ /d "7-Zip.dmg" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg" /ve /t REG_SZ /d "dmg Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,17" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.dmg\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f
reg add "HKCU\Software\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f
reg add "HKCU\Software\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f
reg add "HKCU\Software\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.hfs" /ve /t REG_SZ /d "7-Zip.hfs" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs" /ve /t REG_SZ /d "hfs Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,18" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.hfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f
reg add "HKCU\Software\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f
reg add "HKCU\Software\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f
reg add "HKCU\Software\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.xar" /ve /t REG_SZ /d "7-Zip.xar" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xar" /ve /t REG_SZ /d "xar Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,19" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.xar\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f
reg add "HKCU\Software\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f
reg add "HKCU\Software\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f
reg add "HKCU\Software\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKCU\Software\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Classes\.squashfs" /ve /t REG_SZ /d "7-Zip.squashfs" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs" /ve /t REG_SZ /d "squashfs Archive" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\DefaultIcon" /ve /t REG_SZ /d "C:\Program Files\7-Zip\7z.dll,24" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open" /ve /t REG_SZ /d "" /f
reg add "HKLM\SOFTWARE\Classes\7-Zip.squashfs\shell\open\command" /ve /t REG_SZ /d "\"C:\Program Files\7-Zip\7zFM.exe\" \"%%1\"" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "GlobalAssocChangedCounter" /t REG_DWORD /d "29" /f
goto :finish

:finish
echo 7-Zip settings set!
pause
exit /b 0