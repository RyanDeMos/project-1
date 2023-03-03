# AWS user variables
variable "users" {
    default = ["Ryan", "Huang", "Mireille", "Ali"]
}

# Azure Resource group variables
variable "location" {
    default = "West Europe"
}

variable "RGname" {
    default = "RG01"
}

# Azure User variables
variable "traineeUserPrincipal" {
    default = "ryandemos@examplecorp.com"
}

variable "traineeDisplayName" {
    default = "R. de Mos"
}

variable "trainerUserPrincipal" {
    default = "ibrahimozbekler@examplecorp.com"
}

variable "trainerDisplayName" {
    default = "I. Ozbekler"
}

# Azure storage account variables
variable "storageAccountName" {
    default = "stg-acc-01"
}

variable "storageAccountTier" {
    default = "Standard"
}

variable "storageAccountReplicationType" {
    default = "GRS"
}

# AWS Bucket Variables
variable "s3BucketName" {
    default = "bucket12sh3df0ku"
    # the 12sh3df0ku is random to guarentee globally unique bucket names
}

variable "numberOfBuckets" {
    default = 2
}

# Vm variables
variable "vmName" {
    default = "staging-vm-01"
}

variable "vmSize" {
    default = "Standard_DS1_v2"
}

variable "vm_osProfile_computerName" {
    default = "hostname"
}

variable "vm_osProfile_adminUsername" {
    default = "testadmin"
}

variable "vm_osProfile_adminPassword" {
    default = "Password1234!"
}