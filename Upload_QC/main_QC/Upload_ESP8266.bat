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

"C:\Users\PC\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.9.dev3/esptool.exe" --port "COM%tempChar%" --baud 921600  write_flash --flash_size=detect 0x00000 "D:\QuocHoang\Upload_QC\ESP8266_Firmware\ESP8266_ScanWifi_LED_Blink.bin"

echo Exit code %errorlevel%

if %ERRORLEVEL% EQU 0 (
	color 02
    more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
    
) else (
	color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

:standby

set /p "_var="
if not defined _var goto :start



pause