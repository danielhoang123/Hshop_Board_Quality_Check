@echo off

"C:\Users\%USERNAME%\AppData\Local\Arduino15\packages\rp2040\tools\pqt-python3\1.0.1-base-3a57aed/python3" -I "C:\Users\PC\AppData\Local\Arduino15\packages\rp2040\hardware\rp2040\3.7.2/tools/uf2conv.py" --serial "UF2_Board" --family RP2040 --deploy "D:\QuocHoang\Upload_QC\RP2040_Firmware\FreeRTOS_Pico_BlinkLED_ScanWifi.uf2"

if %ERRORLEVEL% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\Pico wifi.txt"
  
) 
if %ERRORLEVEL% NEQ 0 (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

pause