terraform {
  required_version = ">= 1.0.9"

  required_providers {
    aws        = {
      source  = "hashicorp/aws"
      version = "~> 3.63.0"
    }
    
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "cloudflare" {
  account_id = var.cloudflare_account_id
  api_token = var.cloudflare_api_token
}