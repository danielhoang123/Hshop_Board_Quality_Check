REM https://stackoverflow.com/questions/41934215/batch-file-get-filename-from-directory-and-save-as-variable
@echo off
REM setlocal
set "yourDir=%~dp0"
set "yourExt=*NODEMCU_ESP32S.bin"
rem set filename=''
pushd %yourDir%
for %%a in (%yourExt%) do (
	set "filename=%%a"
	echo !filename!
	echo %%a
	echo %filename%
	
	Goto upload_uno
)

echo .
echo .
echo .
echo not detect file BIN for NODEMCU_ESP32S

set /p DUMMY=Hit ENTER to continue...

:upload_uno
REM for %%a in (%yourExt%) do (
REM REM Do stuff with %%a here
REM Set filename=%%a
REM echo !filename!
REM echo !filename:~0,6!
REM echo !filename:a=b!
REM )

popd
REM endlocal

echo %filename%

D:\arduino_board\esp_tool_upload/BIN_UPLOAD_NODE_ESP32S.bat %filename%

set /p DUMMY=Hit ENTER to continue...