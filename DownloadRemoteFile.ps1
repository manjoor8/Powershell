clear

try {
    $response = Invoke-RestMethod -Uri 'https://example.com/api/your-endpoint'
    if ($response.StatusCode -eq 200) {
        $response.RawContent | Set-Content -Path "output.zip" -Encoding Byte
    } else {
        Write-Host "HTTP Status Code: $($response.StatusCode)"
        Write-Host "HTTP Status Description: $($response.StatusDescription)"
    }
} catch {
    Write-Host "Error: $($_.Exception.Message)"
}
