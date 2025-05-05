@REM Documents:
@REM https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences?redirectedfrom=MSDN


@echo off && setlocal enabledelayedexpansion

for /f "tokens=2 delims=COM:" %%i in ('mode^|findstr /C:"COM"')do set "_com=%%i"
set tempChar=!_com!
call :setESC
echo Starting %ESC%[1m%ESC%[97m%ESC%[41mTermite%ESC%[0m at %ESC%[1m%ESC%[97m%ESC%[102mCOM%tempChar%%ESC%[0m

D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Port=%tempChar% 
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Handshake=0
D:\QuocHoang\Upload_QC\tools\inifile64\inifile.exe "C:\Program Files (x86)\Termite\Termite.ini" [Settings] Baud=115200

Start "" /b "C:\Program Files (x86)\Termite\Termite.exe"

REM tasklist | find /I "Termite.exe"
REM if errorlevel 1 (
   REM Do Something
   REM echo hello
REM ) ELSE (
   REM Do Nothing
   REM echo lohee
REM )

REM timeout /T 20 /nobreak
REM taskkill /im Termite.exe

goto :checkIfTermiteStillExist

:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)

:checkIfTermiteStillExist
for /f "tokens=2 delims=COM:" %%i in ('mode^|findstr /C:"COM"') do set "_com1=%%i"
if "!_com1!"=="" (
	taskkill /im Termite.exe
	exit /b
) else (
    goto checkIfTermiteStillExist
)

pause
