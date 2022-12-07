terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.34.0"
    }
  }

}
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg-k8s" {
  location = "switzerlandnorth"
  name     = "rg-k8s"
  tags     = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_virtual_network" "vn-k8s" {
  name                = "vn-k8s"
  resource_group_name = azurerm_resource_group.rg-k8s.name
  location            = azurerm_resource_group.rg-k8s.location
  address_space       = ["10.123.123.0/24"]
  tags                = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_subnet" "subnet-k8s-a-27" {
  name                 = "subnet-k8s-a-27"
  resource_group_name  = azurerm_resource_group.rg-k8s.name
  virtual_network_name = azurerm_virtual_network.vn-k8s.name
  address_prefixes     = ["10.123.123.0/27"]

}

resource "azurerm_network_security_group" "sg-k8s" {
  name                = "sg-k8s"
  resource_group_name = azurerm_resource_group.rg-k8s.name
  location            = azurerm_resource_group.rg-k8s.location

  tags = {
    environment  = "dev"
    subscription = "free"
  }
}

resource "azurerm_network_security_rule" "sr-k8s" {
  name                        = "sr-k8s"
  access                      = "Allow"
  direction                   = "Inbound"
  priority                    = 100
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.sg-k8s.name
  resource_group_name         = azurerm_resource_group.rg-k8s.name
}

resource "azurerm_subnet_network_security_group_association" "snsga-k8s-a-27" {
  network_security_group_id = azurerm_network_security_group.sg-k8s.id
  subnet_id                 = azurerm_subnet.subnet-k8s-a-27.id
}

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

resource "azurerm_linux_virtual_machine" "vm1" {
  name                  = "vm1"
  admin_username        = "adminuser"
  location              = azurerm_resource_group.rg-k8s.location
  resource_group_name   = azurerm_resource_group.rg-k8s.name
  network_interface_ids = [azurerm_network_interface.nic-k8s.id]
  size                  = "Standard_B1s"
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

  custom_data = filebase64("customdata.tpl")

  tags = {
    environment  = "dev"
    subscription = "free"

  }
}


