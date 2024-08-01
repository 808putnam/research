# Determines the server configuration we are going to deploy
variable "plan" {
  description = "Latitude.sh server plan"
  default     = "c3-large-x86" # https://www.latitude.sh/pricing
}
 
# Determines the location we are going to deploy to
variable "region" {
  description = "Latitude.sh server region slug"
  default     = "NYC" # https://www.latitude.sh/locations
}

# Set via a TF_VAR_ssh_public_key environment variable 
variable "ssh_public_key" {
  description = "Latitude.sh SSH public key"
}

# Set via a TF_VAR_project environment variable
variable "project" {
  description = "Latitude.sh project id"
}
