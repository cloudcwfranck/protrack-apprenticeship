# Input variables for Milestone 01
#
# These variables allow your infrastructure to be:
# - Reusable across environments (dev, staging, prod)
# - Testable with different inputs
# - Configurable without code changes
#
# Best practices:
# - Use validation blocks to catch errors early
# - Provide clear descriptions for documentation
# - Set sensible defaults where appropriate
# - Never put secrets in variables—use Azure Key Vault

variable "location" {
  description = "Azure region for all resources. Using eastus2 for cost optimization."
  type        = string
  default     = "eastus2"

  validation {
    condition     = var.location == "eastus2"
    error_message = "ProTrack requires eastus2 for consistent pricing and evaluation."
  }
}

variable "environment" {
  description = "Environment name for resource tagging (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  description = "Project name prefix for resource naming (e.g., protrack, myapp)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,12}$", var.project_name))
    error_message = "Project name must be 3-12 lowercase alphanumeric characters."
  }
}

variable "student_id" {
  description = "Your unique student identifier (e.g., your GitHub username or student ID)"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]{3,20}$", var.student_id))
    error_message = "Student ID must be 3-20 lowercase alphanumeric characters or hyphens."
  }
}

variable "tags" {
  description = "Common tags applied to all resources for tracking and cost management"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Platform  = "ProTrack"
  }
}
