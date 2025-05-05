Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c D:\QuocHoang\Upload_QC\Background_Process.bat"
oShell.Run strArgs, 0, false