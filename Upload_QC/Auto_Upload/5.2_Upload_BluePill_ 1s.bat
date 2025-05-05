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

"C:\Users\PC\AppData\Local\Arduino15\packages\STM32\tools\STM32Tools\1.4.0/tools/win/stm32CubeProg.bat" 0 "C:\Users\PC\AppData\Local\arduino\sketches\62613577A38308626D0F49D39748D67E/Blink_led_1s.ino.bin" -g


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