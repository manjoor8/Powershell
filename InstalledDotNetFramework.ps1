#Below script require admin access
$dotNetVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name version -EA 0 | Where { $_.PSChildName -Match '^(?!S)\p{L}'} | Select PSChildName, version
try {
    $versionInfo = Get-ChildItem -Path "HKLM:\SOFTWARE\dotnet\Setup\InstalledVersions\x64"  -ErrorAction Stop 
    $dotNetVersion += [pscustomobject] @{
        PSChildName = "Core"
        Version = $versionInfo.GetValue("Version")
    } 
}
catch {}
$dotNetVersion
