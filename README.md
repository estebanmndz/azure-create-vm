# 🖥️ Azure VM Full Deployment (PowerShell)

## 🧠 Descripción

Este proyecto despliega una máquina virtual completa en Azure utilizando PowerShell (módulo Az), siguiendo buenas prácticas de infraestructura cloud como:

* Idempotencia (evita recrear recursos existentes)
* Seguridad mediante Network Security Group (NSG)
* Parametrización del despliegue
* Uso de tagging para gobernanza de recursos

El objetivo es simular un escenario real de provisión de infraestructura IaaS en entornos corporativos.

---

## 🏗️ Arquitectura

```
Resource Group
│
├── Virtual Network (10.0.0.0/16)
│   └── Subnet (10.0.1.0/24)
│
├── Network Security Group
│   └── Regla: Allow SSH (22)
│
├── Public IP
├── Network Interface
└── Virtual Machine (Ubuntu 22.04)
```

---

## 🔐 Seguridad

* Acceso restringido mediante NSG (solo puerto 22 - SSH)
* Uso de `SecureString` para credenciales
* No exposición innecesaria de servicios
* Separación de recursos de red y cómputo

---

## ⚙️ Características técnicas

* Script completamente parametrizado
* Comprobación de existencia de recursos (idempotencia)
* Manejo de errores con `try/catch`
* Uso de Azure PowerShell (Az module)
* Output informativo tras el despliegue

---

## ▶️ Uso

```powershell
Connect-AzAccount

.\create-vm.ps1 `
  -ResourceGroup "RG-Demo" `
  -Location "westeurope" `
  -VnetName "VNET-Demo" `
  -SubnetName "Subnet-Demo" `
  -VmName "VM-Demo" `
  -AdminUser "azureuser"
```

🔐 Se solicitará la contraseña de forma segura durante la ejecución.

---

## 📊 Output esperado

```
✔️ Resource Group creado
✔️ VNet creada
✔️ NSG configurado
✔️ VM creada correctamente

🌐 IP pública: X.X.X.X
```

---

## ⚠️ Limitaciones

* No incluye balanceador de carga
* No implementa alta disponibilidad
* No integra Azure Key Vault (gestión avanzada de secretos)

---

## 🚀 Mejoras futuras

* Migración a Terraform (Infraestructura como código)
* Integración con Azure Key Vault
* Uso de Managed Identity
* Automatización mediante pipelines CI/CD
