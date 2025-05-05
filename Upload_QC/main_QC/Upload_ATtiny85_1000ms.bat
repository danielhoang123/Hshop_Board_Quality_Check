@echo off && setlocal enabledelayedexpansion

:start
color f
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!

if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    goto :startUploading
)

:startUploading

"C:\Users\PC\AppData\Local\Arduino15\packages\digistump\tools\micronucleus\2.0a4/launcher" -cdigispark --timeout 60 -Uflash:w:D:\QuocHoang\Upload_QC\Attiny85_Firmware\Blink_1000ms.hex:i

if %errorlevel% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
) else (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

:openTermite

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Port=%tempChar% 
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=0
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Baud=115200
start "" "C:\Program Files (x86)\Termite\Termite.exe"
timeout /T 5 /nobreak
taskkill /im Termite.exe

goto :standby

:standby

set /p "_var="
if not defined _var goto :start

pause