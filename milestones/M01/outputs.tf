# Output values for Milestone 01
#
# Outputs serve multiple purposes:
# 1. Display important info after deployment (resource IDs, endpoints)
# 2. Enable evidence collection (scripts read these values)
# 3. Feed into other Terraform modules (if you build multi-module infrastructure)
# 4. Provide proof of successful deployment
#
# Best practices:
# - Mark sensitive outputs appropriately
# - Include helpful descriptions
# - Output IDs for programmatic access
# - Output human-readable names for verification

# ============================================================================
# RESOURCE GROUP OUTPUTS
# ============================================================================

output "resource_group_name" {
  description = "Name of the Resource Group containing M01 resources"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "Azure Resource ID of the Resource Group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
}

# ============================================================================
# STORAGE ACCOUNT OUTPUTS
# ============================================================================
# TODO: Uncomment and complete these outputs after creating the storage account

# output "storage_account_name" {
#   description = "Name of the Storage Account (globally unique)"
#   value       = azurerm_storage_account.main.name
# }

# output "storage_account_id" {
#   description = "Azure Resource ID of the Storage Account"
#   value       = azurerm_storage_account.main.id
# }

# output "storage_account_primary_endpoint" {
#   description = "Primary blob endpoint for the Storage Account"
#   value       = azurerm_storage_account.main.primary_blob_endpoint
# }

# output "storage_account_primary_access_key" {
#   description = "Primary access key for the Storage Account (SENSITIVE)"
#   value       = azurerm_storage_account.main.primary_access_key
#   sensitive   = true  # Prevents key from appearing in logs
# }

# ============================================================================
# DEPLOYMENT METADATA
# ============================================================================

output "deployment_timestamp" {
  description = "Timestamp of when this configuration was applied"
  value       = timestamp()
}

output "milestone" {
  description = "ProTrack milestone identifier"
  value       = "M01"
}

output "student_id" {
  description = "Student identifier for this deployment"
  value       = var.student_id
}
