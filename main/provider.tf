# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.10.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-permanent"
    storage_account_name = "mrwterraformstate"
    container_name       = "terraform-state"
    key                  = "terraform-state-azure-orbital"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}