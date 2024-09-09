terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.66.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

provider "aws" {
  alias = "us_east_1"
  region = "us-east-1"
}

provider "archive" {}

data "aws_caller_identity" "current" {}