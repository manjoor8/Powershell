$storage_account = New-AzureStorageContext -ConnectionString '<Storage-Connection-String>'
$Blobs = Get-AzureStorageBlob -Container '<Container_Name>' -Context $storage_account | Where-Object { $_.Name.ToLower().EndsWith(".txt") } # <= Filter is optional
$blobs | Get-AzureStorageBlobContent -Destination 'c:\temp\files' -Force
