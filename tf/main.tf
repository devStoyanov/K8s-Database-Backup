terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.2"
    }
  }
  cloud {
    organization = "dev-azure-terraform"

    workspaces {
      name = "aks-flask-backup"
    }
  }
}

provider "azurerm" {
  features {}
}

module "linux-vm" {
  source            = "./modules/azure-linux-vm"
  rg_name           = var.rg_name
  rg_location       = var.rg_location
  vm_ports          = var.vm_ports
  username          = var.username
  ssh_public_key_vm = var.ssh_public_key_vm


}

output "vm_ip" {
  value = module.linux-vm.public_ip_address
}

module "aks-cluster" {
  source     = "./modules/azure-aks-cluster"
  prefix     = var.prefix
  location   = var.location
  node_count = var.node_count
}

output "aks_cluster_name" {
  value = module.aks-cluster.aks_cluster_name
}

output "aks_resource_group" {
  value = module.aks-cluster.aks_resource_group
}