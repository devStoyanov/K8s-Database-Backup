terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "my-rg" {
  name     = var.rg_name
  location = var.rg_location
  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_network" "az-vn" {
  name                = "az-network"
  resource_group_name = azurerm_resource_group.my-rg.name
  location            = azurerm_resource_group.my-rg.location
  address_space       = ["10.123.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "az-subnet" {
  name                 = "az-subnet"
  resource_group_name  = azurerm_resource_group.my-rg.name
  virtual_network_name = azurerm_virtual_network.az-vn.name
  address_prefixes     = ["10.123.1.0/24"]
}

resource "azurerm_network_security_group" "az-sg" {
  name                = "my-sg"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "az-dev-rule" {
  name                        = "az-dev-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = var.vm_ports
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my-rg.name
  network_security_group_name = azurerm_network_security_group.az-sg.name
}

resource "azurerm_subnet_network_security_group_association" "az-sga" {
  subnet_id                 = azurerm_subnet.az-subnet.id
  network_security_group_id = azurerm_network_security_group.az-sg.id
}

resource "azurerm_public_ip" "az-ip" {
  name                = "az-ip"
  resource_group_name = azurerm_resource_group.my-rg.name
  location            = azurerm_resource_group.my-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "az-nic" {
  name                = "az-nic"
  location            = azurerm_resource_group.my-rg.location
  resource_group_name = azurerm_resource_group.my-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.az-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.az-ip.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "az-vm" {
  name                  = "az-vm"
  resource_group_name   = azurerm_resource_group.my-rg.name
  location              = azurerm_resource_group.my-rg.location
  size                  = "Standard_B1s"
  admin_username        = var.username
  network_interface_ids = [azurerm_network_interface.az-nic.id]

  custom_data = filebase64("customdata.tpl")

  admin_ssh_key {
    username   = var.username
    public_key = var.ssh_public_key_vm
  }

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

  tags = {
    environment = "dev"
  }
}

data "azurerm_public_ip" "az-ip-data" {
  name                = azurerm_public_ip.az-ip.name
  resource_group_name = azurerm_resource_group.my-rg.name

}
