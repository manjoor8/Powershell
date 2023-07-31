#Below script will give you all Wifi SSID and password stored in your system

$ssidPasswordArray = @()
$netshOutput = netsh wlan show profiles
$ssidNames = $netshOutput | Select-String -Pattern 'All User Profile\s+:\s+(.+)'
foreach ($ssid in $ssidNames) {
    $ssidName = $ssid.Matches.Groups[1].Value.Trim()
    $p = netsh wlan show profile name="$ssidName" key=clear 
    $p = $p | Select-String -Pattern "Key Content\s+:\s+(.+)"
    $p = $p.Matches.Groups[1].Value.Trim()
    $ssidPasswordArray += [PSCustomObject]@{
        SSID = $ssidName
        Password = $p
    }
 }
 $ssidPasswordArray | ConvertTo-Json
