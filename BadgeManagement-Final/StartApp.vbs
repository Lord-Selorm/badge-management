Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

' Get the directory where this script is located
scriptDir = fso.GetParentFolderName(WScript.ScriptFullName)

' Start the server
WshShell.CurrentDirectory = scriptDir
WshShell.Run "cmd /c node server.js", 0, False

' Wait a moment for the server to start
WScript.Sleep 2000

' Open the browser
WshShell.Run "http://localhost:3000"
