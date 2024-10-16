 provider "azurerm" {
  features {}

  # Optional: Specify the subscription ID if you're using multiple subscriptions
  subscription_id = "your-subscription-id"  # Replace with your actual subscription ID
}

# Define the existing resource group
data "azurerm_resource_group" "rg" {
  name = "your-resource-group-name"  # Replace with your actual resource group name
}

# Define the existing storage account
data "azurerm_storage_account" "existing_storage_account" {
  name                 = "your-storage-account-name"  # Replace with your storage account name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Create the blob storage container within the existing storage account
resource "azurerm_storage_container" "example_container" {
  name                  = "mycontainer"  # Name of your blob container
  storage_account_name   = data.azurerm_storage_account.existing_storage_account.name
  container_access_type  = "private"  # Can be "private", "blob", or "container"
}
