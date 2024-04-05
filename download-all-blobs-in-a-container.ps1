$storage_account = New-AzureStorageContext -ConnectionString '<Storage-Connection-String>'
$Blobs = Get-AzureStorageBlob -Container '<Container_Name>' -Context $storage_account | Where-Object { $_.Name.ToLower().EndsWith(".txt") } | Get-AzureStorageBlobContent -Destination 'c:\temp\files' -Force # <= Where Filter is optional
