clear
#Download and install specific .Net framework version if it is not already installed.
$version = ""
$versionToInstall = "7.0.9"
$installerPath = "$env:TEMP\dotnet_installer.exe"

try {
  $versionInfo = Get-ChildItem -Path "HKLM:\SOFTWARE\dotnet\Setup\InstalledVersions\x64"  -ErrorAction SilentlyContinue
  $version = $versionInfo.GetValue("Version") 
}
catch {}

if($version -ne $versionToInstall)
{
    try {
        $downloadUrl = "https://download.visualstudio.microsoft.com/download/pr/a1918362-b09b-4593-a4b1-e5f0d9bd68b0/2470e7376871b57867655c057e878800/dotnet-hosting-7.0.9-win.exe"        
        Invoke-WebRequest -Uri $downloadUrl -OutFile $installerPath
        Start-Process -FilePath $installerPath  -ArgumentList "/q /norestart" -Wait
         $versionInfo = Get-ChildItem -Path "HKLM:\SOFTWARE\dotnet\Setup\InstalledVersions\x64"
         $version = $versionInfo.GetValue("Version")
        "Downloaded and installed framework version : $version"
    }
    catch {
        "An error occurred.."
    }
}
else
{
    "Version $version of framework is already installed"
}
