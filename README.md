# project-1
Project 1 repo for DevOps

The main.tf file creates all of the required resources. The resource blocks are written in the order that they are created and the order is guarenteed by using the depends_on meta-argument.

The variables.tf file contains all of the variables for the arguments of the resources. The file is organized by grouping the variables that are used in the same resource together.

The providers.tf file contains the provider blocks.

The output.tf file contains the output blocks for the resource group and location of the azure vm that is created in the main.tf file. 