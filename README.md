# research
## Terraform
**References**
1. https://www.latitude.sh/guides/terraform
2. https://registry.terraform.io/providers/latitudesh/latitudesh/latest/docs

### AWS

**Identity**

We use the IAM identity:
```
terraform
```

Permissions: PowerUserAccess

A set of access keys were created and added to GitHub Codespace Secrets (see below).

**S3**

We use the following S3 bucket for the terraform backend (TODO: Create a unique bucket name here):
```
terraform
```

The bucket setting `Block public access` has been turned off.
The following Bucket policy was added to limit access to the IAM user `terraform`.
```
{
    "Version": "2012-10-17",
    "Id": "Policy1721568914053",
    "Statement": [
        {
            "Sid": "Stmt1721568906157",
            "Effect": "Allow",
            "Principal": {
                "AWS": "TODO: Input your arn for your IAM user here"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::terraform"
        }
    ]
}
```

### GitHub Codespace Secrets
LATITUDESH_AUTH_TOKEN

Authorization token for Latitude.

LATITUDE_SSH_PRIVATE_KEY

The SSH private key we will use to access our Latitude servers.

IMPORTANT:
When pulling the value for this environment variable, remove last newline character from the value for the private key created by ssh-keygen.
In Bash scripts, use double quotes around the environment variable to preserve the newline characters in the value.

LATITUDE_SSH_PROJECT_ID

The default Latitude project id we will deploy our Latitude servers into.

LATITUDE_SSH_PUBLIC_KEY

The SSH public key we will use to access our Latitude servers.
Created by ssh-keygen.

TERRAFORM_AWS_ACCESS_KEY_ID

The AWS access key id for the terraform IAM user (see above).

TERRAFORM_AWS_REGION

The AWS region for the terraform S3 bucket (see above).

TERRAFORM_AWS_SECRET_ACCESS_KEY

The AWS secret access key for the terraform IAM user (see above).


### Scripts

**postCreateCommand.sh**

At the end of the `postCreateCommand.sh` script that runs upon GitHub Codespace creation , we have a section dedicated to taking the GitHub Codespace secrets that represent our Latitude ssh key and creating an actual ssh file representation of them.

*Notes*

1. A set of files representing the ssh key are created.
2. The necessary `chmod 600` command is run on the private key.
3. Pay attention to the comments in the script for how to pull the value for the secret key when creating the codespace secret for it.
4. Note that double quotes around the codespace environment variable for the ssh private key are needed to preserve newline characters.

```
# postCreateCommand.sh
.
echo "Setup an  ssh key for latitude server access"
mkdir -p /root/.ssh 
touch /root/.ssh/latitude.pub 
touch /root/.ssh/latitude
# Public key 
echo $LATITUDE_SSH_PUBLIC_KEY > /root/.ssh/latitude.pub
# Private key
echo "-----BEGIN OPENSSH PRIVATE KEY-----" > /root/.ssh/latitude
# IMPORTANT:
# 1. When pulling the value for this environment variable,
#    remove last newline character from the value for the 
#    private key created by ssh-keygen.
# 2. Use quotes to preserve the newline characters in the value.
echo "$LATITUDE_SSH_PRIVATE_KEY" >> /root/.ssh/latitude
echo "-----END OPENSSH PRIVATE KEY-----" >> /root/.ssh/latitude
chmod 600 /root/.ssh/latitude
.
```

**tf.sh**

To centralize the definition of the numerous environment variables that are required for proper creation of Latitude server instances, we use the `tf.sh` script in the terraform folder.

Examine this script to see how the following environment variables are defined from codespace secrets for:
- Amazon S3 backend configuration for terraform
- Latitude.sh authorization. key to be picked up by the terraform latitude.sh provider
- Terraform variables (i.e., `TF_VAR_*`) that reference environment variables

A typical run of this script would be:
```
./tf.sh cmd=plan
```

Run `./tf.sh --help` for further details.

### Implementation
**main.tf**

The `main.tf` file holds the definition for our AWS S3 back end and the latitude terraform provider.

**variables.tf**

The `variables.tf` file holds definitions for the following variables:
- plan
- region
- ssh_public_key
- project

Note that `ssh_public_key` and project are set via `TF_VAR_*` variables set in `tf.sh`.

**ssh.tf**

The `ssh.tf` file defines the ssh key we will use to access our Latitude server instance.

Note that it uses the `ssh_public_key` variable we created above from a `TF_VAR_*` variable set in `tf.sh`.

**server.tf**

The `server.tf` file creates the latitude server instance.

Note that the plan, project and region come from our variables we created above. And the `ssh_keys` comes from the key we created in `ssh.tf`.

**outputs.tf**

Upon successful completion of creation of a latitude server instance, the ip for the instance will be printed to the console. You can also login to the latitude dashboard to locale the server instance and click on it to find the ip for it.

### Connecting to a running latitude instance
Once a server instance is created, you can login to the latitude dashboard and select the server instance to find out the credential to use to access it. This is usually `ubuntu`.

With that info in hand, and with your terraform ssh key created in the  `/root/.ssh` folder via the `postCreateCommand.sh` (see above), you can issue the following command to connect:

```
ssh -i /root/.ssh/terraform ubuntu@<ip for server instance>
```
