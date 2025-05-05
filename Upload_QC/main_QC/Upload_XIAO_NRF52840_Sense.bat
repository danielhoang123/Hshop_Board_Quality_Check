@echo off && setlocal enabledelayedexpansion

:start
cls
color f
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set _comPort=!_com!
echo %_comPort%
mode com%_comPort% baud=12 PARITY=n DATA=8 STOP=1 TO=ON XON=OFF ODSR=OFF OCTS=OFF DTR=OFF RTS=OFF IDSR=OFF
timeout /t 2

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set _comPort=!_com!
if "%_comPort%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    "C:\Users\PC\AppData\Local\Arduino15\packages\Seeeduino\hardware\mbed\2.9.2/tools/adafruit-nrfutil/win32/adafruit-nrfutil.exe" --verbose dfu serial -pkg "D:\QuocHoang\Upload_QC\Xiao_Firmware\XIAO_NRF52840_Sense_RGB_IMU.zip" -p COM%_comPort% -b 115200 --singlebank
    
    if %ERRORLEVEL% EQU 0 (
        color 02
        more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
        goto :openTermite
    )

    if %ERRORLEVEL% NEQ 0 (
        color 04
        more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
        goto :standby
    )
)

:openTermite

timeout /t 2 /nobreak
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set _comPort=!_com!

if "%_comPort%" == "1" (
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
) else (
    D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Port=%_comPort% 
    D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=1
    D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Baud=11520
 
    timeout /T 20 /nobreak
    D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=0
    taskkill /im Termite.exe
    goto :standby
)

:standby
more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
set /p "_var="
if not defined _var goto :start

pause