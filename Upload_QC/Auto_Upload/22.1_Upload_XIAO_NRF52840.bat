@echo off && setlocal enabledelayedexpansion

:start
cls
color f 
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set "tempChar=!_com!"
mode com%tempChar% baud=12 PARITY=n DATA=8 STOP=1 TO=ON XON=OFF ODSR=OFF OCTS=OFF DTR=OFF RTS=OFF IDSR=OFF
timeout /t 2
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    "C:\Users\PC\AppData\Local\Arduino15\packages\Seeeduino\hardware\mbed\2.9.2/tools/adafruit-nrfutil/win32/adafruit-nrfutil.exe" --verbose dfu serial -pkg "D:\QuocHoang\Upload_QC\Xiao_Firmware\XIAO_NRF52840_Blink_RGB_100ms.zip" -p COM%tempChar% -b 115200 --singlebank
    if %ERRORLEVEL% EQU 0 (
        color 02
        more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
    ) 
    if %ERRORLEVEL% NEQ 0 (
        color 04
        more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
    )
)

:standby
set /p "_var="
if not defined _var goto :start
pause