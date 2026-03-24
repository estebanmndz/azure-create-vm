# Crear una VM completa en Azure
# Requiere: Az PowerShell Module
# Ejecutar: Connect-AzAccount

param(
    [string]$ResourceGroup = "RG-Demo",
    [string]$Location = "westeurope",
    [string]$VnetName = "VNET-Demo",
    [string]$SubnetName = "Subnet-Demo",
    [string]$VmName = "VM-Demo",
    [string]$AdminUser = "azureuser",
    [string]$AdminPassword = "P@ssw0rd123!"
)

# 1. Crear RG
New-AzResourceGroup -Name $ResourceGroup -Location $Location

# 2. Crear red
$subnet = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix "10.0.1.0/24"
$vnet = New-AzVirtualNetwork -Name $VnetName -AddressPrefix "10.0.0.0/16" -Subnet $subnet `
    -Location $Location -ResourceGroupName $ResourceGroup

# 3. IP pública
$publicIP = New-AzPublicIpAddress -Name "$VmName-ip" -ResourceGroupName $ResourceGroup `
    -Location $Location -AllocationMethod Static

# 4. NIC
$nic = New-AzNetworkInterface -Name "$VmName-nic" -ResourceGroupName $ResourceGroup `
    -Location $Location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $publicIP.Id

# 5. Configuración de la VM
$cred = New-Object System.Management.Automation.PSCredential ($AdminUser,(ConvertTo-SecureString $AdminPassword -AsPlainText -Force))

$vmConfig = New-AzVMConfig -VMName $VmName -VMSize "Standard_B1s" |
    Set-AzVMOperatingSystem -Linux -ComputerName $VmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName "Canonical" -Offer "UbuntuServer" -Skus "18.04-LTS" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# 6. Crear VM
New-AzVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vmConfig
