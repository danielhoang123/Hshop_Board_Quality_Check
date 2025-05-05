@echo off && setlocal enabledelayedexpansion

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
set "tempChar=!_com!"
mode com%tempChar% baud=1200 PARITY=n DATA=8 STOP=1 TO=ON XON=OFF ODSR=OFF OCTS=OFF DTR=OFF RTS=OFF IDSR=OFF
timeout /t 2

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
set tempChar=!_com!
"C:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\bossac\1.7.0-arduino3/bossac.exe" -i -d --port=COM%tempChar% -U true -i -e -w -v "D:\QuocHoang\Upload_QC\SAMD21_Firmware\SAMD21_Blink_100ms.bin" -R
  if %ERRORLEVEL% EQU 0 (
        color 02
        more "D:\QuocHoang\Upload_QC\Graphic\Ok.txt"
       
    ) 
    if %ERRORLEVEL% NEQ 0 (
        color 04
        more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
    )
pause