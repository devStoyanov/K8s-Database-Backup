output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.az-vm.name}: ${data.azurerm_public_ip.az-ip-data.ip_address}"
}