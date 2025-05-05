@echo off && setlocal enabledelayedexpansion

:start
color f
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
timeout /t 1

if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    goto :startUploading
)

:startUploading

"C:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/bin/avrdude" "-CC:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/etc/avrdude.conf" -v -V -patmega2560 -cwiring "-PCOM%tempChar%" -b115200 -D "-Uflash:w:D:\QuocHoang\Upload_QC\Arduino_Firmware\QC_Firmware_Vietduino_4__n17_11_2019_MEGA2560.hex:i"

if %ERRORLEVEL% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
) 
if %ERRORLEVEL% NEQ 0 (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

:standby
set /p "_var="
if not defined _var goto :start

pause