resource "azurerm_virtual_machine_extension" "vm_extension" {
  name                 = "vm-extension"
  virtual_machine_id   = azurerm_linux_virtual_machine.backend_vm.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
      "commandToExecute": "sudo apt update -y && sudo apt install nginx -y && echo 'Hello from POC Web App' > /var/www/html/index.html && sudo systemctl restart nginx"
    }
  SETTINGS
}