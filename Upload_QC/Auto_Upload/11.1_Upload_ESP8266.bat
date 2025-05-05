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
    @rem put main command line here
    @rem "C:\Users\PC\AppData\Local\Arduino15\packages\Seeeduino\hardware\mbed\2.9.2/tools/adafruit-nrfutil/win32/adafruit-nrfutil.exe" --verbose dfu serial -pkg "C:\Users\PC\AppData\Local\Temp\arduino\sketches\90D8A93F6C2646640711ED5031BBD6AD/Blink.ino.zip" -p COM%tempChar% -b 115200 --singlebank
    "C:\Users\PC\AppData\Local\Arduino15\packages\esp8266\tools\python3\3.7.2-post1/python3" -I "C:\Users\PC\AppData\Local\Arduino15\packages\esp8266\hardware\esp8266\3.1.2/tools/upload.py" --chip esp8266 --port "COM%tempChar%" --baud "921600" ""  --before default_reset --after hard_reset write_flash 0x0 "D:\QuocHoang\Upload_QC\ESP8266_Firmware\ESP8266_ScanWifi_LED_Blink.bin"
    if %ERRORLEVEL% NEQ 0 then (
		color 04
        more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
        goto :standby
    ) 
    else
        color 02
        more "D:\QuocHoang\Upload_QC\Graphic\Pico wifi.txt"
        goto :standby
    )
	fi
)

:standby

set /p "_var="
if not defined _var goto :start



pause