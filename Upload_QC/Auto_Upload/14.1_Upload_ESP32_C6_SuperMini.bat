@echo off && setlocal enabledelayedexpansion

:start
"C:\Users\PC\AppData\Local\Arduino15\packages\esp32\tools\esptool_py\4.9.dev3/esptool.exe" --chip esp32c6 --baud 921600  --before default_reset --after hard_reset write_flash  -z --flash_mode keep --flash_freq keep --flash_size keep 0x0 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C6_SuperMini\WiFiScan.ino.bootloader.bin" 0x8000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C6_SuperMini\WiFiScan.ino.partitions.bin" 0xe000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32_32S\boot_app0.bin" 0x10000 "D:\QuocHoang\Upload_QC\ESP32_Firmware\ESP32C6_SuperMini\WiFiScan.ino.bin"
  if %ERRORLEVEL% EQU 0 (
        color 02
        more "D:\QuocHoang\Upload_QC\Graphic\Pico wifi.txt"
       
    ) 
    if %ERRORLEVEL% NEQ 0 (
        color 04
        more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
    )
timeout /t 2
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
set tempChar=!_com!
if "%tempChar%" == "1" (echo error) else (
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Port=%tempChar% 
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=0


timeout /T 20 /nobreak
@rem D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=0
taskkill /im Termite.exe

goto :standby
)

:standby
set "var="
set /p "var=Nap them nhan Enter"
if not defined var goto :start
pause 