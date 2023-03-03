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
  depends_on = [azurerm_resource_group.RG01] # Added to guarentee the order of creation
}


# Creates the trainer in azure and requires them to change password during the next login
resource "azuread_user" "trainer" {
  user_principal_name = "${var.trainerUserPrincipal}"
  display_name        = "${var.trainerDisplayName}"
  force_password_change = "true"
  depends_on = [azuread_user.trainee] # Added to guarentee the order of creation
}


# Creates the S3 buckets
resource "aws_s3_bucket" "b" {
    bucket = "${var.s3BucketName}-${count.index}"
    count = var.numberOfBuckets
    depends_on = [azuread_user.trainer]# Added to guarentee the order of creation
}


# Creates the four new aws users
resource "aws_iam_user" "new_users" {
    for_each = toset(var.users)
    name = each.value
    depends_on = [aws_s3_bucket.b]# Added to guarentee the order of creation
}


# Creates the azure storage account
resource "azurerm_storage_account" "stg_acc" {
  name                     = "${var.storageAccountName}"
  resource_group_name      = azurerm_resource_group.RG01.name
  location                 = azurerm_resource_group.RG01.location
  account_tier             = "${var.storageAccountTier}"
  account_replication_type = "${var.storageAccountReplicationType}"

  tags = {
    environment = "test"
  }
  depends_on = [aws_iam_user.new_user]
}


# Creates a linux virtual machine in Azure
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.vmName}"
  location              = azurerm_resource_group.RG01.location
  resource_group_name   = azurerm_resource_group.RG01.name
  network_interface_ids = []
  vm_size               = "${var.vmSize}"
  depends_on = [azurerm_storage_account.stg_acc]

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
    computer_name  = "${var.vm_osProfile_computerName}"
    admin_username = "${var.vm_osProfile_adminUsername}"
    admin_password = "${var.vm_osProfile_adminPassword}"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "test"
  }
}


