REM @echo off && setlocal enabledelayedexpansion
REM for /f "tokens=2delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"&echo/!_com!
REM pause

@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims=COM:" %%i in ('mode^|findstr /C:"COM"') do set "_com=%%i"

if "!_com!"=="" (
    echo _com is empty
) else (
    echo _com is not empty: !_com!
)

pause
