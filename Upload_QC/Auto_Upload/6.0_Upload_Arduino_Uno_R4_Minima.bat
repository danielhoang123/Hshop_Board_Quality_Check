@echo off

"C:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\dfu-util\0.11.0-arduino5/dfu-util" -D "D:\QuocHoang\Upload_QC\Arduino_Firmware\QC_Firmware_Arduino_R4_Minima.bin" -a0 -Q

if %ERRORLEVEL% EQU 0 (
    color 02
    more "D:\QuocHoang\Upload_QC\Graphic\OK.txt"
	call :standby
) 
if %ERRORLEVEL% NEQ 0 (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\Upload_Error.txt"
)

:standby
set /p "_var="
echo Continue please press "Enter"
if not defined _var goto :start
endlocal
pause
