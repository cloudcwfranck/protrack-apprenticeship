# Milestone 01: Azure Fundamentals
#
# Learning Objectives:
# - Understand Azure resource organization (Resource Groups)
# - Deploy storage with security best practices
# - Implement proper naming conventions
# - Apply tags for cost tracking and organization
#
# Requirements:
# 1. Create 1 Resource Group
# 2. Create 1 Storage Account with:
#    - Secure defaults (HTTPS only, TLS 1.2+)
#    - Standard LRS replication (cost-optimized)
#    - Proper naming (must be globally unique)
#    - Required tags
#
# Success Criteria:
# - `terraform plan` runs without errors
# - `terraform apply` successfully deploys
# - All resources appear in Azure portal
# - Evidence script captures deployment proof

# ============================================================================
# LOCALS
# ============================================================================
# Locals help build consistent naming and reduce repetition
# Pattern: {project}-{environment}-{student}-{resource_type}

locals {
  # Naming prefix used across all resources
  name_prefix = "${var.project_name}-${var.environment}-${var.student_id}"

  # Storage account name (must be globally unique, lowercase, no hyphens)
  # Azure requirement: 3-24 characters, alphanumeric only
  storage_account_name = lower(replace("${var.project_name}${var.environment}${var.student_id}sa", "-", ""))

  # Merge default tags with milestone-specific tags
  common_tags = merge(
    var.tags,
    {
      Milestone   = "M01"
      Environment = var.environment
      StudentID   = var.student_id
    }
  )
}

# ============================================================================
# RESOURCE GROUP
# ============================================================================
# Resource Groups are logical containers for Azure resources.
# Best practice: 1 Resource Group per milestone for clean isolation.

resource "azurerm_resource_group" "main" {
  name     = "${local.name_prefix}-rg"
  location = var.location

  tags = local.common_tags
}

# ============================================================================
# STORAGE ACCOUNT
# ============================================================================
# TODO: Create an Azure Storage Account resource
#
# Requirements:
# - Use the resource type: azurerm_storage_account
# - Name must use: local.storage_account_name
# - Location must use: azurerm_resource_group.main.location
# - Resource group must reference: azurerm_resource_group.main.name
# - Set account_tier to: "Standard"
# - Set account_replication_type to: "LRS" (Locally Redundant Storage)
# - Enable HTTPS-only traffic (https_traffic_only_enabled = true)
# - Set minimum TLS version to: "TLS1_2"
# - Apply tags using: local.common_tags
#
# Documentation: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
#
# Example structure:
# resource "azurerm_storage_account" "main" {
#   name                     = local.storage_account_name
#   resource_group_name      = azurerm_resource_group.main.name
#   location                 = azurerm_resource_group.main.location
#   account_tier             = "Standard"
#   account_replication_type = "LRS"
#
#   # Security settings
#   https_traffic_only_enabled = true
#   min_tls_version           = "TLS1_2"
#
#   tags = local.common_tags
# }
#
# UNCOMMENT AND COMPLETE THE ABOVE CODE

# ============================================================================
# OPTIONAL ENHANCEMENTS (Beyond Minimum Requirements)
# ============================================================================
# Once you complete the basic requirements, consider:
# - Adding a storage container (azurerm_storage_container)
# - Implementing lifecycle management rules
# - Enabling blob versioning
# - Adding diagnostic settings for monitoring
#
# These are NOT required for M01 but demonstrate deeper Azure knowledge.
# Completed by cloudcwfranck on Tue Dec 30 17:30:18 EST 2025
