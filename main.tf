# --------------------------
# terraform configuration
# --------------------------
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  profile = "terraform"
  region  = "ap-northeast-1"
}

variable "project" {
  type = string
}

variable "domain" {
  type = string
}