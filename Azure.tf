 provider "azurerm" {
  features {}

  # (Optional) Specify the subscription ID to ensure you are working with the correct subscription
  subscription_id = "36629079-fbde-4dce-b2b9-e42435dfa1d3"  # Replace this with your actual Azure subscription ID
}

# Reference the existing resource group
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "Harness_IACM"   # Customize the VM name
  location              = "(US) West Central US"      # Location should match the region of the existing resource group
  resource_group_name   = "QuadrantFabricRG"  # Replace with your existing resource group name
  size                  = "Standard_D2s_v3"  # VM size

  admin_username = "azureuser"

  # SSH public key for VM access
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("C:/Users/Hello/.ssh/id_rsa.pub")  # Path to your SSH public key file
  }

  # Define the OS disk configuration
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  # Define the image for the VM (Ubuntu 18.04 LTS)
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
