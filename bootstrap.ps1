function Download-Dependency($url, $output_dir, $file_name)
{
    Invoke-WebRequest $url -OutFile "$output_dir\$file_name.zip"
    
    Write-Host "extracting in $output_dir\$file_name..."
    Expand-Archive -Path "$output_dir\$file_name.zip" -DestinationPath $output_dir -Force
    Remove-Item "$output_dir\$file_name.zip"
}

# godot engine
$godot_version="4.3"
$url = "https://github.com/godotengine/godot/releases/download/$godot_version-stable/Godot_v$godot_version-stable_win64.exe.zip"
$output_dir = "bin"
if (!(Test-Path "$output_dir\Godot_v$godot_version-stable_win64.exe")) {
    Write-Host "downloading godot..."
    Download-Dependency $url $output_dir "godot"
}

# plugin gdterm
$plugin_version="0.99.1"
$url = "https://github.com/markeel/gdterm/archive/refs/tags/v$plugin_version.zip"
$output_dir = "Addons"
if (!(Test-Path "$output_dir\gdterm")) {
    Write-Host "downloading gdterm plugin..."
    Download-Dependency $url $output_dir "gdterm"

    Move-Item -Path "Addons\gdterm-$plugin_version\addons\gdterm\*" -Destination "Addons\gdterm\."
    Remove-Item -Recurse "Addons\gdterm-$plugin_version"
}

# plugin godot-git-plugin
$plugin_version="v3.1.1"
$url = "https://github.com/godotengine/godot-git-plugin/releases/download/$plugin_version/godot-git-plugin-$plugin_version.zip"
$output_dir = "Addons"
if (!(Test-Path "$output_dir\godot-git-plugin")) {
    Write-Host "downloading godot-git-plugin..."
    Download-Dependency $url $output_dir "godot-git-plugin"

    Move-Item -Path "Addons\godot-git-plugin-$plugin_version\addons\godot-git-plugin\*" -Destination "Addons\godot-git-plugin\."
    Remove-Item -Recurse "Addons\godot-git-plugin-$plugin_version"
}

# setup ssh
Write-Host "generating ssh keys..."
ssh-keygen -t rsa -m pem

Write-Host "opening browser..."
Start-Process "https://github.com/settings/keys"

Write-Host "add your generated public key into github"