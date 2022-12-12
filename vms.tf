resource "azurerm_public_ip" "pip-k8s" {
  name                = "pip-k8s"
  allocation_method   = "Dynamic"
  location            = azurerm_resource_group.rg-k8s.location
  resource_group_name = azurerm_resource_group.rg-k8s.name

  tags = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_public_ip" "pip-vm2" {
  name                = "pip-vm2"
  allocation_method   = "Dynamic"
  location            = azurerm_resource_group.rg-k8s.location
  resource_group_name = azurerm_resource_group.rg-k8s.name

  tags = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_network_interface" "nic-k8s" {
  name                = "nic-k8s"
  location            = azurerm_resource_group.rg-k8s.location
  resource_group_name = azurerm_resource_group.rg-k8s.name
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-k8s.id
    subnet_id                     = azurerm_subnet.subnet-k8s-a-27.id
  }
  tags = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_network_interface" "nic-vm2" {
  name                = "nic-vm2"
  location            = azurerm_resource_group.rg-k8s.location
  resource_group_name = azurerm_resource_group.rg-k8s.name
  ip_configuration {
    name                          = "internal"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip-vm2.id
    subnet_id                     = azurerm_subnet.subnet-k8s-a-27.id
  }
  tags = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                  = "vm1"
  admin_username        = "adminuser"
  location              = azurerm_resource_group.rg-k8s.location
  resource_group_name   = azurerm_resource_group.rg-k8s.name
  network_interface_ids = [azurerm_network_interface.nic-k8s.id]
  size                  = var.vm_size
  custom_data           = filebase64("customdata.tpl")


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa_azure_k8s.pub")
  }


  tags = {
    environment  = "dev"
    subscription = "free"

  }
}

resource "azurerm_linux_virtual_machine" "vm2" {
  name                  = "vm2"
  admin_username        = "adminuser"
  location              = azurerm_resource_group.rg-k8s.location
  resource_group_name   = azurerm_resource_group.rg-k8s.name
  network_interface_ids = [azurerm_network_interface.nic-vm2.id]
  size                  = var.vm_size
  custom_data           = filebase64("customdata.tpl")


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }


  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa_azure_k8s.pub")
  }


  tags = {
    environment  = "dev"
    subscription = "free"

  }
}


#Data Section
data "azurerm_public_ip" "ip-data" {
  name                = azurerm_public_ip.pip-k8s.name
  resource_group_name = azurerm_resource_group.rg-k8s.name
}

data "azurerm_public_ip" "ip-vm2" {
  name                = azurerm_public_ip.pip-vm2.name
  resource_group_name = azurerm_resource_group.rg-k8s.name
}

output "vm1-ip" {
  value = "${azurerm_linux_virtual_machine.vm1.name} : ${data.azurerm_public_ip.ip-data.ip_address}"
}

output "vm2-ip" {
  value = "${azurerm_linux_virtual_machine.vm2.name} : ${data.azurerm_public_ip.ip-vm2.ip_address}"
}
