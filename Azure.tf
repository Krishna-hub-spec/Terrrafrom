 provider "azurerm" {
  features {}

   # Service Principal authentication details
  subscription_id = "36629079-fbde-4dce-b2b9-e42435dfa1d3"  # Replace with your Azure Subscription ID
  client_id       = "1d7e8a86-9635-4994-a146-2063686bc265"        # Replace with your Service Principal Client ID
  client_secret   = "JRW8Q~m2jSEgTK7Kzcdg4sXU3lXYg71clGG8lb7e"    # Replace with your Service Principal Client Secret
  tenant_id       = "0eadb77e-42dc-47f8-bbe3-ec2395e0712c"        # Replace with your Azure Tenant ID
}

# Define the existing resource group
data "azurerm_resource_group" "rg" {
  name = "QuadrantFabricRG"  # Replace with your actual resource group name
}

# Define the existing storage account
data "azurerm_storage_account" "existing_storage_account" {
  name                 = "fabrichealthcarepoc"  # Replace with your storage account name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Create the blob storage container within the existing storage account
resource "azurerm_storage_container" "example_container" {
  name                  = "harness-container01"  # Name of your blob container
  storage_account_name   = data.azurerm_storage_account.existing_storage_account.name
  container_access_type  = "blob"  # Can be "private", "blob", or "container"
}
