provider "aws" {
    
  
}

terraform {
  required_providers {
    aws = {
      source  = "opentofu/aws" #"hashicorp/aws" or "opentofu/aws" for opentofu -specific registry 
      version = ">= 5.0" # Specify your desired version constraint
    }
  }
}