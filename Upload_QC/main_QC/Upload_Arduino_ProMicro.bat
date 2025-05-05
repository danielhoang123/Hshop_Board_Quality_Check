@echo off && setlocal enabledelayedexpansion

REM for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
REM set "tempChar=!_com!"
REM mode com%tempChar% BAUD=12 PARITY=n DATA=8 STOP=1 TO=ON XON=OFF ODSR=OFF OCTS=OFF DTR=OFF RTS=OFF IDSR=OFF
REM timeout /t 1 /nobreak

REM for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
REM set "tempChar=!_com!"
REM if "%tempChar%" == "1" (echo Tat phan mem ket noi COM/PORT) else (
    REM timeout /t 1
    REM "C:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/bin/avrdude" "-CC:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/etc/avrdude.conf" -v -V -patmega32u4 -cavr109 -PCOM%tempChar% -b57600 -D -Uflash:w:D:\QuocHoang\Upload_QC\Arduino_Firmware\y21m10d15_QC_Firmware_Vietduino_5_Leonardo.hex:i
	
	
REM )

:start

color f

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
mode com%tempChar% BAUD=12 PARITY=n DATA=8 STOP=1 TO=ON XON=OFF ODSR=OFF OCTS=OFF DTR=OFF RTS=OFF IDSR=OFF
timeout /t 2 /nobreak

for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
set "tempChar=!_com!"
if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    goto :startUploading
)

:startUploading

"C:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/bin/avrdude" "-CC:\Users\PC\AppData\Local\Arduino15\packages\arduino\tools\avrdude\6.3.0-arduino17/etc/avrdude.conf" -v -patmega32u4 -cavr109 -PCOM%tempChar% -b57600 -D -Uflash:w:D:\QuocHoang\Upload_QC\Arduino_Firmware\QC_Firmware_Vietduino_4__n17_11_2019_Micro.hex:i

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