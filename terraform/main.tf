terraform {
    backend "s3" {
        bucket="terraform" # TODO: update to your bucket name
        key = "latitude/terraform.tfstate" # TODO: update to the key you want to use (will create if not there)
  }
  required_providers {
    latitudesh = {
      source  = "latitudesh/latitudesh"
      version = "~> 1.1.3" # Make sure you are using the latest version published to the Terraform registry
    }
  }
}
