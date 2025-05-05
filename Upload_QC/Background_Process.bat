REM https://stackoverflow.com/questions/27772861/get-serial-com-port-description-in-windows-batch

@echo off & setlocal

:startSearching

set /A a=0

for /f "delims=" %%I in ('wmic path Win32_SerialPort get DeviceID^,Caption^,Description^,Name^,ProviderType /format:list ^| find "="') do (
    set "%%I"
	if "%DeviceID%" equ "COM" do (
		set /A a =a+1
	)
)

echo %a%

if "%Description%" == "Arduino Uno" ( 
	start D:\QuocHoang\Upload_QC\Upload_Arduino_Uno.bat 
) else (
	goto :startSearching
)

pause 