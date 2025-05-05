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

"C:\Users\PC\AppData\Local\Arduino15\packages\stm32duino\tools\stm32tools\2022.9.26/win/stlink_upload.bat" "C:\Users\PC\AppData\Local\arduino\sketches\2200B39457B65F7AAF7AE53EC42906E9/Blink_led_100ms.ino.bin"




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