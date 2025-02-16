# Ensure script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Please run this script as Administrator!"
    exit
}

# Get all installed IIS features (including sub-features)
$features = Get-WindowsFeature | Where-Object { $_.Installed -eq $true -and $_.Name -match "^Web" }

# Check if any IIS features are installed
if ($features.Count -eq 0) {
    Write-Host "No IIS components found on this server."
    exit
}

# Extract feature names
$featureNames = $features.Name

# Define file path
$exportFilePath = "C:\IISComponents.txt"

# Export to a text file
$featureNames | Out-File -FilePath $exportFilePath

Write-Host "IIS components exported to $exportFilePath"
