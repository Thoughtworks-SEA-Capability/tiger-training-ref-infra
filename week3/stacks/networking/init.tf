terraform {
  backend "s3" {
    region = "ap-southeast-1"
    bucket = "infra-training-state-2022"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.27.0"
    }
  }
  #tflint-fix
  required_version = "~> 1.2.1"
}

provider "aws" {
  region = "ap-southeast-1"
  #tfsec-custom-fix
  default_tags  {
    tags = {
      owner = "platform"
    }
  }
}
