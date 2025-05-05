@echo off && setlocal enabledelayedexpansion

:start
color f
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
timeout /t 2

if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    @rem put main command line here
    @rem "C:\Users\PC\AppData\Local\Arduino15\packages\Seeeduino\hardware\mbed\2.9.2/tools/adafruit-nrfutil/win32/adafruit-nrfutil.exe" --verbose dfu serial -pkg "C:\Users\PC\AppData\Local\Temp\arduino\sketches\90D8A93F6C2646640711ED5031BBD6AD/Blink.ino.zip" -p COM%tempChar% -b 115200 --singlebank
    goto :startUploading
)

:startUploading
"C:\Users\%USERNAME%\AppData\Local\Arduino15\packages\rp2040\tools\pqt-python3\1.0.1-base-3a57aed/python3" -I "C:\Users\%USERNAME%\AppData\Local\Arduino15\packages\rp2040\hardware\rp2040\3.7.2/tools/uf2conv.py" --serial "COM%tempChar%" --family RP2040 --deploy "D:\QuocHoang\Upload_QC\Xiao_Firmware\XIAO_RP2040_RGB.uf2"
if %ERRORLEVEL% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"

) 
if %ERRORLEVEL% NEQ 0 (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)
goto :standby

:standby
set /p "_var="
if not defined _var goto :start 

pause