# Creates the azure resource group
resource "azurerm_resource_group" "RG01" {
  name     = "${var.RGname}"
  location = "${var.location}"
  tags = {
    source = "terraform"
  }
}


# Creates the trainee in azure
resource "azuread_user" "trainee" {
  user_principal_name = "${var.traineeUserPrincipal}"
  display_name        = "${var.traineeDisplayName}"
}


# Creates the trainer in azure and requires them to change password during the next login
resource "azuread_user" "trainer" {
  user_principal_name = "${var.trainerUserPrincipal}"
  display_name        = "${var.trainerDisplayName}"
  force_password_change = "true"
}


# Creates the S3 buckets
resource "aws_s3_bucket" "b" {
    bucket = "${var.s3BucketName}-${count.index}"
    count = var.numberOfBuckets
}


# Creates the four new aws users
resource "aws_iam_user" "new-users" {
    for_each = toset(var.users)
    name = each.value
}


# Creates the azure storage account
resource "azurerm_storage_account" "stg-acc" {
  name                     = "${var.storageAccountName}"
  resource_group_name      = azurerm_resource_group.RG01.name
  location                 = azurerm_resource_group.RG01.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}


# Creates a linux virtual machine in Azure
resource "azurerm_virtual_machine" "main" {
  name                  = "staging-vm-01"
  location              = azurerm_resource_group.RG01.location
  resource_group_name   = azurerm_resource_group.RG01.name
  network_interface_ids = []
  vm_size               = "Standard_DS1_v2"


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
    environment = "staging",
    source = "terraform"
  }
}


