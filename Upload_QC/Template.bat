@echo off && setlocal enabledelayedexpansion

:start
color f
for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
timeout /t 2

if "%tempChar%" == "1" (
    color 04
    more "D:\QuocHoang\Upload_QC\Graphic\COM_Error.txt"
    goto :standby
) else (
    goto :startUploading
)

:startUploading

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