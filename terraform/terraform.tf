terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21.1"
    }
  }

  required_version = "~> 1.4.6"
}