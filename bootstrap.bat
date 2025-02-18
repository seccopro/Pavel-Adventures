@echo off
setlocal EnableDelayedExpansion

set GODOT_DOWNLOAD_URI=https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip

call :setup
if errorlevel 1 exit /b %ERRORLEVEL%

exit /b %ERRORLEVEL%

:setup
if exist %~dp0..\bin\Godot_v4.3-stable_win64.exe exit /b 0
echo downloading godot...
powershell -Command "Invoke-WebRequest %GODOT_DOWNLOAD_URI% -OutFile godot.zip"
goto extract

:extract
echo extracting godot into bin...
rmdir /Q /S bin >NUL 2>NUL
powershell Expand-Archive godot.zip -DestinationPath bin
exit /b %ERRORLEVEL%
