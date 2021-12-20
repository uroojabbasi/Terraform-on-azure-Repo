
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.81.0"
    }
  }
}
provider "azurerm" {
  features {}
 // subscription_id = "568bde55-da11-4f23-9387-d52dcf5ca3c0"
  //tenant_id       = "927a12e2-7f40-466b-9b48-616dcc202ef5"
}

  //resource "azurerm_resource_group" "rg" {
   //name="rg_12"
 //location="eastus"
// }


resource "azurerm_resource_group" "fe-rg" {
  name     = "fe-rg"
  location = "westeurope"
}

resource "azurerm_virtual_network" "fe-rg" {
  name                = "fe-vnet"
  address_space       = ["10.0.0.0/23"]
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
}

resource "azurerm_subnet" "fe-rg-01" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "fe-rg-02" {
  name                 = "jbox-subnet"
  resource_group_name  = azurerm_resource_group.fe-rg.name
  virtual_network_name = azurerm_virtual_network.fe-rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "fe-rg" {
  name                = "pub-ip01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "fe-rg" {
  name                = "fw-01"
  location            = azurerm_resource_group.fe-rg.location
  resource_group_name = azurerm_resource_group.fe-rg.name
  ip_configuration {
    name                 = "fwip-config"
    subnet_id            = azurerm_subnet.fe-rg-01.id
    public_ip_address_id = azurerm_public_ip.fe-rg.id
  }
  //test
}
