@echo off
setlocal EnableDelayedExpansion

set GODOT_ENGINE_URI=https://github.com/godotengine/godot/releases/download/4.3-stable/Godot_v4.3-stable_win64.exe.zip
set GODOT_GDTERM_PLUGIN_URI=https://github.com/markeel/gdterm
set GODOT_GIT_PLUGIN_URI=https://github.com/godotengine/godot-git-plugin/releases/download/v3.1.1/godot-git-plugin-v3.1.1.zip
set GIT_SSH_SETTINGS_URI=https://github.com/settings/keys

call :download_engine
if errorlevel 1 exit /b %ERRORLEVEL%
call :download_gdterm_plugin
if errorlevel 1 exit /b %ERRORLEVEL%
call :download_git_plugin
if errorlevel 1 exit /b %ERRORLEVEL%
call :setup_git_ssh_keys
if errorlevel 1 exit /b %ERRORLEVEL%

exit /b %ERRORLEVEL%

:download_engine
if exist bin\Godot_v4.3-stable_win64.exe exit /b 0
echo downloading godot...
powershell Invoke-WebRequest %GODOT_ENGINE_URI% -OutFile godot.zip
goto extract_engine

:extract_engine
echo extracting godot into bin...
rmdir /Q /S bin >NUL 2>NUL
powershell Expand-Archive godot.zip -DestinationPath bin
powershell Remove-Item godot.zip
exit /b %ERRORLEVEL%

:download_gdterm_plugin
if exist Addons\gdterm exit /b 0
rmdir /Q /S Addons/gdterm >NUL 2>NUL
echo downloading gdterm plugin...
pushd Addons
git clone -n --depth=1 --filter=tree:0 %GODOT_GDTERM_PLUGIN_URI% gdterm
cd gdterm
git sparse-checkout set --no-cone /addons/gdterm
git checkout
powershell Move-Item -Path addons/gdterm/* -Destination .
powershell Remove-Item -Recurse addons
popd
exit /b %ERRORLEVEL%

:download_git_plugin
if exist Addons\godot-git-plugin exit /b 0
echo downloading git plugin...
powershell Invoke-WebRequest %GODOT_GIT_PLUGIN_URI% -OutFile godot_git_plugin.zip
goto extract_git_plugin

:extract_git_plugin
echo extracting git plugin into Addons...
rmdir /Q /S Addons/godot-git-plugin >NUL 2>NUL
powershell Expand-Archive godot_git_plugin.zip -DestinationPath Addons/godot-git-plugin
powershell Move-Item -Path Addons/godot-git-plugin/godot-git-plugin-v3.1.1/addons/godot-git-plugin/* -Destination Addons/godot-git-plugin/.
powershell Remove-Item -Recurse Addons/godot-git-plugin/godot-git-plugin-v3.1.1
powershell Remove-Item godot_git_plugin.zip
exit /b %ERRORLEVEL%

:setup_git_ssh_keys
echo generating ssh keys...
ssh-keygen -t rsa -m pem
goto open_browser

:open_browser
echo opening browser
powershell Start-Process %GIT_SSH_SETTINGS_URI%
exit /b %ERRORLEVEL%