# Creates the trainee in azure
resource "azuread_user" "trainee" {
  user_principal_name = "ryandemos@examplecorp.com"
  display_name        = "R. de Mos"
}

# Creates the trainer in azure and requires them to change password during the next login
resource "azuread_user" "trainer" {
  user_principal_name = "ibrahimozbekler@examplecorp.com"
  display_name        = "I. Ozbekler"
  force_password_change = "true"
}

resource "aws_iam_user" "new-users" {
    for_each = toset(var.users)
    name = each.value
}

resource "azurerm_resource_group" "RG01" {
  name     = "RG01"
  location = "${var.location}"
  tags = {
    source = "terraform"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "staging-vm-01"
  location              = azurerm_resource_group.RG01.location
  resource_group_name   = azurerm_resource_group.RG01.name
  network_interface_ids = []
  vm_size               = "Standard_DS1_v2"
  tags = {
    source = terraform
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

