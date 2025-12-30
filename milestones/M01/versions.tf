# Terraform version and provider constraints
#
# Why these constraints exist:
# - Terraform >= 1.6: Ensures modern syntax support and security patches
# - azurerm ~> 3.0: Locks to major version 3.x to prevent breaking changes
# - Feature flags: Required for consistent provider behavior across environments
#
# DO NOT modify these constraints without understanding the implications.
# CI validates that these exact versions are used.

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    # Enable soft-delete for Key Vault (production safety)
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }

    # Resource group protection
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }

  # Fail fast if subscription is not accessible
  skip_provider_registration = false
}
