Import-Module WebAdministration

$OldThumbprint = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
$NewThumbprint = "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB"

$oldTP = $OldThumbprint.ToUpper()
$newTP = $NewThumbprint.ToUpper()

$sites = Get-ChildItem IIS:\Sites

foreach ($site in $sites) {

    foreach ($binding in $site.Bindings.Collection) {

        if ($binding.protocol -ne "https") {
            continue
        }

        $bindingInfo = $binding.bindingInformation
        $sslFlags    = $binding.sslFlags

        # Get current cert hash
        $currentHash = $binding.CertificateHash
        if (-not $currentHash) { continue }

        $currentThumbprint = ($currentHash | ForEach-Object { $_.ToString("X2") }) -join ""

        if ($currentThumbprint -ne $oldTP) {
            continue
        }

        Write-Host "Updating cert on site '$($site.Name)' binding '$bindingInfo'"

        # Remove existing cert
        $binding.RemoveSslCertificate()

        # Re-assign new cert
        $binding.AddSslCertificate($newTP, "My")
    }
}

Write-Host "All matching bindings updated successfully."
