# Root Template

This folder contains the main Terraform script used to call the component modules to create the necessary infrastructure.

### Prerequisites
- Azure subscription with Owner role

### Dev-Container Setup

Using a devcontainer is the *easiest* way to evaluate the Dataops Solution Kit, as all of the following tools necessary for the core infrastructure deployment are already installed.
  - Bash/Z shell
  - [Terraform v1.3.5+](https://developer.hashicorp.com/terraform/downloads)
  - [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)

To get started with creating a devcontainer, follow these steps:
1. Go through the devcontainer [installation guide](https://code.visualstudio.com/docs/devcontainers/containers#_installation)
2. Open this current repository, as cloned in your local machine, within a devcontainer. Refer to these [steps](https://code.visualstudio.com/docs/devcontainers/containers#_quick-start-open-an-existing-folder-in-a-container) to do so.

### Pre-Deployment

The pre-deployment step creates the following resources necessary to run the main Terraform script:
- Service Principal with Owner role to authenticate Terraform
- Azure Storage Account and Blob Container to store the Terraform backend state
- Resource Group to store the Storage Account

```bash

# Navigate to the root templates dir (repo_dir/core-infrastructure/terraform/root)
cd core-infrastructure/terraform/root

# Connecting to Azure with specific tenant (e.g. microsoft.onmicrosoft.com)
az login --tenant '{Tenant}'

# change the active subscription using the subscription name
az account set --subscription "{Subscription Id or Name}"

# Run pre-deployment step
# OPTIONAL args: ./pre-deploy.sh -l <Azure region> -e <environment> -h
# By default, region is "westeurope" and environment is "dev"
./pre-deploy.sh -l westeurope -e dev

```

### Run deployment script locally (Optional)

Running the main deployment locally is<span style="color:red"> **optional** and **not recommended**</span>. The recommended way to run the main deployment script is to run via the CI/CD pipeline. Refer to the [pipeline documentation](../../.pipelines/README.md) to run the deployment script through the pipeline.

#### Note
- Use a shorter environment name, because the same is suffixed to the resource group created by this pre-deployment script, longer environment name could impact resources with name length restrictions. i.e dev or test
- remember to use the same name in the azure devops pipeline when releasing the code using CD pipeline.

If you opt to run the deployment script *locally*, continue below. Repeat these steps to rerun the terraform deployment.

```bash

# if your terminal environment gets cleared, you can source the file to reload the environment variables
source .avdataops-tf.env

# Initialize terraform config
terraform init \
  -backend-config="resource_group_name=$AVOPS_TF_RG_NAME" \
  -backend-config="storage_account_name=$AVOPS_STORAGE_ACCOUNT_NAME" \
  -backend-config="container_name=$AVOPS_CONTAINER_NAME"

# Verify deployment config values in <env>.tfvars file

# Plan terraform deployment
terraform plan -var-file="dev.tfvars"

# Execute terraform deployment
terraform apply -var-file="dev.tfvars" -auto-approve

# Clear env vars
unset `env | grep -E 'AVOPS_|ARM_' | egrep -o '^[^=]+'`

```

### Cleanup

```bash

# Navigate to the root templates dir (repo_dir/core-infrastructure/terraform/root)
cd core-infrastructure/terraform/root

# Set env vars
source .avdataops-tf.env

# Tear down deployment
terraform destroy

# Clear env vars
unset `env | grep -E 'AVOPS_|ARM_' | egrep -o '^[^=]+'`

```

### Accessing resources within private network

By design, the components will be deployed within a virtual network and interact with one another using private endpoints. To connect to any of these resources within the private network for debugging or any additional configuration, you will require a Bastion host attached to the same network.

By default, the Terraform script does **not** create a Bastion host in the main deployment. Deploy a Bastion host by enabling the `bastion_host_enabled` parameter in the `<env>.tfvars` file and rerun the deploy.

Once the Bastion host is ready, access the Bastion VM password from Key Vault and connect to the Bastion instance as follows.

```bash

# Set env vars
source .avdataops-tf.env

# Assign key vault access policy to view secrets
AVOPS_KV_RG_NAME=`az group list --tag environment=$AVOPS_ENV_NAME --query '[].name' -o tsv`
AVOPS_KV_NAME=`az keyvault list -g $AVOPS_KV_RG_NAME --query '[].name' -o tsv`
AVOPS_OBJECT_ID=`az account show --query id`

az keyvault set-policy -n $AVOPS_KV_NAME --object-id $AVOPS_OBJECT_ID --secret-permissions get list

# Access Bastion password in Azure portal by navigating to specific key vault resource
# https://learn.microsoft.com/en-us/azure/key-vault/secrets/quick-create-portal#retrieve-a-secret-from-key-vault

# Connect to the Bastion instance using the password
# https://learn.microsoft.com/en-us/azure/bastion/bastion-connect-vm-rdp-windows

# Delete key vault access policy when done 
az keyvault delete-policy -n $AVOPS_KV_NAME --object-id $AVOPS_OBJECT_ID

# Clear env vars
unset `env | grep -E 'AVOPS_|ARM_' | egrep -o '^[^=]+'`

```
