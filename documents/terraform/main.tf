terraform {
  // {} Blocks
  // Configures the Terraform backend and required providers
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.3.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "6.43.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }

  }
}

provider "aws" {
  region = "ap-south-1" // AWS region
}
