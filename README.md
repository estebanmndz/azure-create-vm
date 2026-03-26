# 🖥️ Azure Virtual Machine Deployment (PowerShell)

![Azure](https://img.shields.io/badge/Azure-Compute-blue)
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-blue)
![IaaS](https://img.shields.io/badge/IaaS-Infrastructure-green)

> 💡 Deploy a secure and fully configured Linux Virtual Machine in Azure using Infrastructure-as-a-Service principles

---

## 🧠 Overview

This project automates the deployment of a **Linux Virtual Machine (Ubuntu 22.04)** in Microsoft Azure, including full networking and security configuration.

It simulates a real-world infrastructure provisioning scenario using PowerShell and Azure Resource Manager.

**Technologies used:**

* Azure PowerShell (Az Module)
* Azure Virtual Machines (Compute)
* Azure Networking (VNet, Subnet, NIC, NSG)
* Azure Resource Manager

---

## 🎯 Objective

The goal of this project is to:

* Provision a complete infrastructure in Azure
* Deploy a secure Virtual Machine
* Apply basic security and governance practices

---

## 🏗️ Architecture

```
[Resource Group]
        ↓
[Virtual Network (10.0.0.0/16)]
        ↓
[Subnet (10.0.1.0/24)]
        ↓
[Network Security Group]
        ↓
[Network Interface]
        ↓
[Public IP (Static, Standard)]
        ↓
[Linux Virtual Machine (Ubuntu 22.04)]
```

---

## ⚙️ Key Components

The deployment includes:

* **Resource Group** → logical container
* **Virtual Network & Subnet** → network isolation
* **Network Security Group (NSG)** → inbound traffic control (SSH allowed)
* **Public IP (Static, Standard SKU)** → external access
* **Network Interface (NIC)** → connectivity
* **Virtual Machine (Ubuntu 22.04)** → compute resource

---

## 🧩 How It Works

The script performs:

1. Authenticates to Azure using `Connect-AzAccount`
2. Validates or creates the Resource Group
3. Creates or reuses Virtual Network and Subnet
4. Creates a Network Security Group with SSH access rule
5. Creates Public IP and Network Interface
6. Configures and deploys a Linux Virtual Machine
7. Outputs connection details (public IP and username)

---

## 🔐 Security Considerations

* Uses **Network Security Group (NSG)** to control inbound traffic
* Allows only SSH (port 22) by default
* Credentials handled via **SecureString**
* Public IP exposure should be further restricted in production

---

## 🏷️ Tagging Strategy

Resources are tagged for governance:

* Environment → Lab
* Owner → Esteban
* Project → Azure-VM-Deployment

---

## 🌍 Real-World Use Case

This setup can be used to:

* Deploy development or testing environments
* Host applications in Azure
* Simulate enterprise infrastructure provisioning
* Practice cloud automation and networking

---

## ▶️ Usage

```powershell
Connect-AzAccount

.\create-vm.ps1 `
    -ResourceGroup "RG-Demo" `
    -Location "westeurope" `
    -VnetName "vnet-demo" `
    -SubnetName "subnet-demo" `
    -VmName "vm-demo" `
    -AdminUser "azureuser" `
    -AdminPassword (Read-Host -AsSecureString)
```

---

## 📊 Example Output

```
🚀 Creando VM...
🌐 Red configurada
🔒 NSG aplicado
🖥️ VM creada correctamente

🌍 IP pública: XX.XX.XX.XX
🔑 Usuario: azureuser
```

---

## 🚀 Future Improvements

* Restrict SSH access by IP range
* Use SSH keys instead of password authentication
* Add Azure Monitor / diagnostics
* Implement Managed Identity
* Convert to Terraform (IaC)

---

## 📌 Key Takeaways

This project demonstrates:

* End-to-end Azure infrastructure provisioning
* Networking and security configuration
* Use of Infrastructure-as-a-Service (IaaS)
* Real-world cloud engineering practices

---
