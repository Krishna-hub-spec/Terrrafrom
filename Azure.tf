 provider "azurerm" {
  features {}
  subscription_id = "36629079-fbde-4dce-b2b9-e42435dfa1d3"  # Replace with your actual Azure subscription ID
}

# Use an existing resource group or specify the one you want to use
resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "West US"  # Must match the existing resource group region
  resource_group_name = "QuadrantFabricRG"  # Replace with your existing resource group
}

resource "azurerm_subnet" "subnet" {
  name                 = "example-subnet"
  resource_group_name  = "QuadrantFabricRG"  # Replace with your existing resource group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = "West US"  # Must match the existing resource group region
  resource_group_name = "QuadrantFabricRG"  # Replace with your existing resource group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "Harness_IACM-vm"
  location              = "West US"  # Must match the existing resource group region
  resource_group_name   = "QuadrantFabricRG"  # Replace with your existing resource group
  size                  = "Standard_DS1_v2"
  network_interface_ids = [azurerm_network_interface.nic.id]  # Add the network interface

  admin_username = "azureuser"

  # Add your SSH public key here directly (you can get it from ~/.ssh/id_rsa.pub)
  admin_ssh_key {
    username   = "azureuser"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCrKAxF8GynvOHmGBK5vsH7SABAbzOLKOY6P1DWqPOTBodfmpSrCh8
KnQY0nDTSMLMJuw7d9bFE24iesUFuSi3J9WZEgZgvymtaro7v9LjKqhg1L4t7/
iW0svfhgcra+SAs9HrjZLxvN/ePhZz2wMKhq0mJc+VFa0/
G7NCj3+AbuEbquEHZHMEbzSkEmF1noeLAHo+gztjA+TkkC5tmZACVDz5Y7K5G4p8kVkjs9LiPehSREg0D8u
NASjIKg2M/fEZNhP+ZfaVJ4OJbjfyGcmU1ATYcXgix7ePR0/uk3IRV/
e6JGiaIgoAPtmTlVNAQ1dSb8CiD+8eodbGBk366/+Fj"  # Replace with your actual SSH public key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "production"
  }
}
