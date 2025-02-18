resource "azurerm_public_ip" "vm_public_ip" {
  name                = "vm-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "vm_nic" {
  name = "vm-nic"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet_web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.vm_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "backend_vm" {
  name = "backend-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location = var.location
  size = "Standard_B1s"

  admin_username = var.vm_admin_username
  admin_password = var.vm_admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.vm_nic.id]

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      user = var.vm_admin_username
      password = var.vm_admin_password
      host = azurerm_network_interface.vm_nic.private_ip_address
    }
    inline = [
      "sudo apt update -y",
      "sudo apt install nginx -y",
      "echo 'Hello from POC Web App' | sudo tee /var/www/html/index.html",
      "sudo systemctl restart nginx"
    ]
  }
}

