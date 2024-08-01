#!/bin/bash

# Display help menu
usage() {
    echo ""
    echo "tf.sh"
    echo "==============================================================================="
    echo  ""
    echo "General script to setup appropriate environment and run a terrafrom command."
    echo ""
    echo "-------------------------------------------------------------------------------"
    echo "Options"
    echo "-------------------------------------------------------------------------------"
    echo "-h|--help              Displays help menu"
    echo ""
    echo "--cmd=<option>         Specify the terraform command to run."
    echo "                       init"
    echo "                       validate"
    echo "                       plan"
    echo "                       apply"
    echo "                       destroy"
    echo "-------------------------------------------------------------------------------"
    echo ""

    exit
}

# Parse input arguments
for i in "$@"
do
case $i in
    -h|--help)
    usage
    shift
    ;;
    -i|--cmd=*)
    CMD="${i#*=}"
    shift
    ;;
    *)
    echo "Unknown option: $i"
    usage
    shift
    ;;
esac
done

# Validate input arguments and set defaults
if [[ "$CMD" != "init"  && \
      "$CMD" != "validate"  && \
      "$CMD" != "plan"   && \
      "$CMD" != "apply"     && \
      "$CMD" != "destroy" ]]; then
    echo "Invalid -i|--cmd: $CMD"
    usage
fi

# Amazon S3 backend configuration for terraform
export AWS_ACCESS_KEY_ID=$TERRAFORM_AWS_ACCESS_KEY_ID
export AWS_REGION=$TERRAFORM_AWS_REGION
export AWS_SECRET_ACCESS_KEY=$TERRAFORM_AWS_SECRET_ACCESS_KEY

echo "AWS Identity for terraform actions:"
aws sts get-caller-identity

# Latitude.sh auth. key to be picked up by terrform latitude.sh provider
export LATITUDESH_AUTH_TOKEN=$LATITUDESH_AUTH_TOKEN

# Terraform var's that reference environment variables
export TF_VAR_ssh_public_key=$LATITUDE_SSH_PUBLIC_KEY
export TF_VAR_project=$LATITUDE_SSH_PROJECT_ID

# Run terraform command
terraform $CMD
