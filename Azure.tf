 provider "azurerm" {
  features {}

  # Optional: Specify the subscription ID if you're using multiple subscriptions
  subscription_id = "36629079-fbde-4dce-b2b9-e42435dfa1d3"  # Replace with your actual subscription ID
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
  name                  = "harness-container"  # Name of your blob container
  storage_account_name   = data.azurerm_storage_account.existing_storage_account.name
  container_access_type  = "blob"  # Can be "private", "blob", or "container"
}
