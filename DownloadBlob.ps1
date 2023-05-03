clear
$acName = "<storage_acoount_name>"
$acKey = "<storage_account_key" #Access key for your storage account
$acCN = "<container_name>" 
$localFolder = 'd:\temp\download' #Local folder   
$p = "<blob url prefix>" # https://<acname>.blob.core.windows.net/<container>/

if (Test-Path -Path $localFolder) {   

    $container = az storage container list --prefix $acCN --account-key $acKey --account-name $acName
    $blobs = az storage blob list --container-name $acCN --account-key $acKey --account-name $acName --query "[].{Name:name}" 
    $blobs = $blobs | ConvertFrom-Json
    foreach ($b in $blobs)
    {
        if($b.Name.ToLower().EndsWith('txt')){
            $bu = $p + $b.Name
            Write-Host -NoNewline ("Downloading blob :  " +  $b.Name)
            $lf =  Join-Path $localFolder $b.Name
            az storage blob download --container-name $acCN --account-key $acKey --blob-url $bu --file $lf  --account-name $acName  
            Write-Host "   ....Done"
        }
    }
}
else{
    Write-Host "Local folder does not exist.."
 }
