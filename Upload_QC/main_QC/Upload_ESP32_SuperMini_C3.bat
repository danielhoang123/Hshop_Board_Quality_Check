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

"C:\Users\PC\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.9.dev3/esptool.exe" --chip esp32c3 --port "COM%tempChar%" --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x0 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C3_SuperMini_Plus\WiFiScan_RGB_LED.bootloader.bin" 0x8000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C3_SuperMini_Plus\WiFiScan_RGB_LED.partitions.bin" 0xe000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_32S\boot_app0.bin" 0x10000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C3_SuperMini_Plus\WiFiScan_RGB_LED.bin"

if %ERRORLEVEL% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\Pico wifi.txt"
   
) else (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

:standby

set /p "_var="
if not defined _var goto :start 

pause

