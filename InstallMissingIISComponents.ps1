# Import feature list from the exported file
$featureNames = Get-Content -Path "C:\IISComponents.txt"

# Get installed features on this server
$installedFeatures = Get-WindowsFeature | Where-Object { $_.Installed -eq $true } | Select-Object -ExpandProperty Name

# Find missing features
$missingFeatures = $featureNames | Where-Object { $installedFeatures -notcontains $_ }

# Install missing features
if ($missingFeatures.Count -gt 0) {
    Write-Host "Installing missing IIS components..."
    Install-WindowsFeature -Name $missingFeatures -IncludeManagementTools
    Write-Host "Installation complete. Reboot may be required."
} else {
    Write-Host "All IIS components are already installed."
}
