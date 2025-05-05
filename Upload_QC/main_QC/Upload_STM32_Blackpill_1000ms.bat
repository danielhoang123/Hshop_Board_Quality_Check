@echo off && setlocal enabledelayedexpansion

:start

color f

"C:\Program Files\STMicroelectronics\STM32Cube\STM32CubeProgrammer\bin\STM32_Programmer_CLI.exe" -c port=SWD -d "D:\QuocHoang\Upload_QC\STM32_Firmware\STM32F411CEU6-BlackPill\Blink_PC13_1000ms.bin" 0x08000000 -v -rst

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