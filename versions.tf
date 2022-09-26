terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.20.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.36.1"
    }
  }

  required_version = "1.2.7"

  cloud {
    organization = "wortech"

    workspaces {
      name = "server-dev"
    }
  }
}