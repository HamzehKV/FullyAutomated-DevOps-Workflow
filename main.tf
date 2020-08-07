provider "azurerm" {
  version = "2.5.0"
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "TFRG_BlobStore"
    storage_account_name = "hmzkv88tfstorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

variable "imagebuild" {
  type        = string
  description = "Latest Image Build"
}


resource "azurerm_resource_group" "tfrg_weatherapi" {
  name     = "TFRG_weatherapi"
  location = "westeurope"
}

resource "azurerm_container_group" "tfcg_weatherapi" {
  name                = "TFCG_weatherapi"
  location            = azurerm_resource_group.tfrg_weatherapi.location
  resource_group_name = azurerm_resource_group.tfrg_weatherapi.name

  ip_address_type = "public"
  dns_name_label  = "hamzehwa"
  os_type         = "linux"
  container {
    name   = "weatherapi"
    image  = "hmzkv88/weatherapi:${var.imagebuild}"
    #image  = "hmzkv88/weatherapi"
    cpu    = "1"
    memory = "1"
    ports {
      port     = 80
      protocol = "TCP"
    }

  }
}
