param(
    [Parameter(Mandatory=$true)]
    [string]$ResourceGroup,

    [Parameter(Mandatory=$true)]
    [string]$Location,

    [Parameter(Mandatory=$true)]
    [string]$VnetName,

    [Parameter(Mandatory=$true)]
    [string]$SubnetName,

    [Parameter(Mandatory=$true)]
    [string]$VmName,

    [Parameter(Mandatory=$true)]
    [string]$AdminUser,

    [Parameter(Mandatory=$true)]
    [SecureString]$AdminPassword
)

# =========================
# CONFIG
# =========================
$tags = @{
    Environment = "Lab"
    Owner       = "Esteban"
    Project     = "Azure-VM-Deployment"
}

# =========================
# LOGIN
# =========================
Write-Host "🔐 Conectando a Azure..."
Connect-AzAccount -ErrorAction Stop

# =========================
# RESOURCE GROUP
# =========================
Write-Host "📦 Comprobando Resource Group..."

$rg = Get-AzResourceGroup -Name $ResourceGroup -ErrorAction SilentlyContinue

if (-not $rg) {
    Write-Host "➕ Creando Resource Group..."
    $rg = New-AzResourceGroup -Name $ResourceGroup -Location $Location -Tag $tags
} else {
    Write-Host "✔️ Resource Group ya existe"
}

# =========================
# NETWORK
# =========================
Write-Host "🌐 Configurando red..."

$vnet = Get-AzVirtualNetwork -Name $VnetName -ResourceGroupName $ResourceGroup -ErrorAction SilentlyContinue

if (-not $vnet) {
    $subnetConfig = New-AzVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix "10.0.1.0/24"

    $vnet = New-AzVirtualNetwork `
        -Name $VnetName `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -AddressPrefix "10.0.0.0/16" `
        -Subnet $subnetConfig `
        -Tag $tags

    Write-Host "✔️ VNet creada"
} else {
    Write-Host "✔️ VNet ya existe"
}

# =========================
# NSG (SEGURIDAD)
# =========================
Write-Host "🔒 Creando NSG..."

$nsgName = "$VmName-nsg"

$nsg = New-AzNetworkSecurityGroup `
    -Name $nsgName `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -Tag $tags

# Regla SSH
$nsg | Add-AzNetworkSecurityRuleConfig `
    -Name "Allow-SSH" `
    -Description "Allow SSH" `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 1000 `
    -SourceAddressPrefix "*" `
    -SourcePortRange "*" `
    -DestinationAddressPrefix "*" `
    -DestinationPortRange 22

$nsg | Set-AzNetworkSecurityGroup

# =========================
# PUBLIC IP
# =========================
Write-Host "🌍 Creando IP pública..."

$publicIP = New-AzPublicIpAddress `
    -Name "$VmName-ip" `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -AllocationMethod Static `
    -Sku Standard `
    -Tag $tags

# =========================
# NIC
# =========================
Write-Host "🔌 Creando NIC..."

$nic = New-AzNetworkInterface `
    -Name "$VmName-nic" `
    -ResourceGroupName $ResourceGroup `
    -Location $Location `
    -SubnetId $vnet.Subnets[0].Id `
    -PublicIpAddressId $publicIP.Id `
    -NetworkSecurityGroupId $nsg.Id `
    -Tag $tags

# =========================
# VM CONFIG
# =========================
Write-Host "🖥️ Configurando VM..."

$cred = New-Object System.Management.Automation.PSCredential ($AdminUser, $AdminPassword)

$vmConfig = New-AzVMConfig -VMName $VmName -VMSize "Standard_B1s" |
    Set-AzVMOperatingSystem -Linux -ComputerName $VmName -Credential $cred |
    Set-AzVMSourceImage -PublisherName "Canonical" -Offer "0001-com-ubuntu-server-jammy" -Skus "22_04-lts" -Version "latest" |
    Add-AzVMNetworkInterface -Id $nic.Id

# =========================
# CREATE VM
# =========================
Write-Host "🚀 Creando VM..."

try {
    New-AzVM -ResourceGroupName $ResourceGroup -Location $Location -VM $vmConfig -Tag $tags
    Write-Host "✅ VM creada correctamente"
} catch {
    Write-Host "❌ Error creando la VM"
    Write-Host $_
    exit
}

# =========================
# OUTPUT
# =========================
$ip = (Get-AzPublicIpAddress -Name "$VmName-ip" -ResourceGroupName $ResourceGroup).IpAddress

Write-Host "🌐 IP pública: $ip"
Write-Host "🔑 Usuario: $AdminUser"
