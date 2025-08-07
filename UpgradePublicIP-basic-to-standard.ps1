#This script will not work if you have a loadbalancer before servers
#Right after executing below line you'll be prompted to select your subscription. Choose correct subscription.
Connect-AzAccount

$resourceGroup = "<resource-group-name>"

# Get all VMs in the resource group
$vms = Get-AzVM -ResourceGroupName $resourceGroup

foreach ($vm in $vms) {
    $vmName = $vm.Name
    Write-Host "`n=== Processing VM: $vmName ===" -ForegroundColor Cyan

    # Ask for confirmation
    $confirm = Read-Host "Do you want to upgrade the public IP of $vmName to Standard SKU? (y/n)"
    if ($confirm -ne 'y') {
        Write-Host "Skipping $vmName"
        continue
    }
   
    # Step 1: Get NIC
    $nicId = $vm.NetworkProfile.NetworkInterfaces[0].Id
    $nicName = ($nicId -split "/")[-1]
    $nic = Get-AzNetworkInterface -ResourceGroupName $resourceGroup -Name $nicName
    $ipConfig = $nic.IpConfigurations[0]

    # Step 2: Check for Public IP
    if ($ipConfig.PublicIpAddress -eq $null) {
        Write-Warning "$vmName does not have a public IP. Skipping..."
        continue
    }

    $publicIpId = $ipConfig.PublicIpAddress.Id
    $publicIpName = ($publicIpId -split "/")[-1]
    $publicIp = Get-AzPublicIpAddress -ResourceGroupName $resourceGroup -Name $publicIpName

    if ($publicIp.Sku.Name -ne "Basic") 
    {
        Write-Host "Public IP is not Basic"
        continue
    }

    # Step 3: Deallocate the VM
    Write-Host "Deallocating VM..."
    Stop-AzVM -Name $vmName -ResourceGroupName $resourceGroup -Force

    # Step 4: Disassociate Public IP
    Write-Host "Disassociating public IP: $publicIpName"
    $ipConfig.PublicIpAddress = $null
    Set-AzNetworkInterface -NetworkInterface $nic

    # Step 5: Upgrade Public IP SKU (if Basic)
    if ($publicIp.Sku.Name -eq "Basic") {
        Write-Host "Upgrading public IP to Standard..."
        $publicIp.PublicIpAllocationMethod = "Static"  # Standard requires Static
        $publicIp.Sku.Name = "Standard"
        Set-AzPublicIpAddress -PublicIpAddress $publicIp
        Write-Host "SKU upgraded to Standard"
    } 

    # Step 6: Re-associate Public IP
    Write-Host "Reassociating public IP..."
    $ipConfig.PublicIpAddress = $publicIp
    Set-AzNetworkInterface -NetworkInterface $nic

    # Step 7: Start the VM
    Write-Host "Starting VM..."
    Start-AzVM -Name $vmName -ResourceGroupName $resourceGroup

    Write-Host "Completed for VM: $vmName" -ForegroundColor Green
}
