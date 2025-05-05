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

"D:\QuocHoang\Upload_QC\tools\esptool_py\4.9.dev3\esptool.exe" --chip esp32 --port "COM%tempChar%" --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x1000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_CAM_AI-Thinker\ESP32_CAM.bootloader.bin" 0x8000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_CAM_AI-Thinker\ESP32_CAM.partitions.bin" 0xe000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_CAM_AI-Thinker\boot_app0.bin" 0x10000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_CAM_AI-Thinker\hshop_CameraWebServer_Mode_AP_STATION_Eeprom_ESP32_CAM.bin"

if %ERRORLEVEL% equ 0 (
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

