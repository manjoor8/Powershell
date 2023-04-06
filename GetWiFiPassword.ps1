#This script require Administrator privillage 

# Get the list of wireless profiles
$profiles = netsh wlan show profiles

$list = @()


# Loop through each profile
foreach ($profile in $profiles) {
    # Split the profile string into two parts
    $profileParts = $profile -split ':', 2

    # Check if the second part (profile name) is null or empty
    if ($profileParts[1] -ne $null -and $profileParts[1] -ne '') {
        # Get the profile name and key material
        $profileName = $profileParts[1].Trim()
        $keyMaterial = (netsh wlan show profile name="$profileName" key=clear | Select-String "Key Content").Line.Split(':')[1].Trim()

        #Create a new object and add values
        $o = New-Object -TypeName PSObject
        $o | Add-Member -Name 'SSID' -MemberType NoteProperty -Value $profileName
        $o | Add-Member -Name 'Password' -MemberType NoteProperty -Value $keyMaterial
        
        #Add to List
        $list += $o       
    }
}

 #Print Output 
 $list | Format-Table
