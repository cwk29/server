terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }

    tfe = {
      source  = "hashicorp/tfe"
      version = "0.36.1"
    }

    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "2.18.0"
    # }
  }

  required_version = "1.2.7"

  cloud {
    organization = "wortech"

    workspaces {
      name = "server-dev"
    }
  }
}