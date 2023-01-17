# Root Template

This folder contains the main terraform script used to call the component modules to create the necessary infrastructure. 

### Prerequisites
- Azure subscription and permissions to create: 
  Storage Account, Subnets, VNet, Azure Batch, Data Factory (ADF), Key Vault, Cosmos DB, App Service
- Terraform v1.3.5+ ([download](https://developer.hashicorp.com/terraform/downloads))
- AZ CLI ([download](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest))

### Deployment

Prior running the deployment, it is recommended to initialize a remote storage location for storing the terraform backend state. Refer to the [setup steps](#setup-remote-terraform-backend-storage) to do so.

```bash

export ENV_NAME=dev
export RESOURCE_GROUP_NAME=rg-avdataops-$ENV_NAME
export RESOURCE_GROUP_LOCATION=westeurope

az group create -n $RESOURCE_GROUP_NAME -l $RESOURCE_GROUP_LOCATION

# Navigate to the root templates dir (repo_dir/IaC/root)

# Initialize terraform config
export TF_RG_NAME=rg-tfstate
export TF_STORAGE_ACCOUNT=<TF storage account>
export TF_CONTAINER_NAME=tfstate-$ENV_NAME
export TF_STORAGE_ACCOUNT_KEY="az storage account keys list --resource-group $TF_RG_NAME --account-name $TF_STORAGE_ACCOUNT --query '[0].value' -o tsv"

terraform init \
  -backend-config="resource_group_name=$TF_RG_NAME" \
  -backend-config="storage_account_name=$TF_STORAGE_ACCOUNT" \
  -backend-config="container_name=$TF_CONTAINER_NAME" \
  -backend-config="access_key=$(eval $TF_STORAGE_ACCOUNT_KEY)"


# Plan terraform deployment, per values in terraform.tfvars file
terraform plan

# Execute terraform deployment
terraform apply

```

### Cleanup

```bash

# Navigate to the root templates dir (repo_dir/IaC/root)

# Tear down deployment
terraform destroy

```

### Setup Remote Terraform Backend Storage

It is recommended to configure an Azure storage account to use as a remote backend for your terraform state files. Otherwise, terraform will create and use a locally saved state files. The local approach is not ideal when multiple users and/or systems are running the terraform scripts.

```bash

export TF_RG_NAME=rg-tfstate
export TF_RG_LOCATION=westeurope
export ENV_NAME=dev
export STORAGE_ACCOUNT_NAME=avopstfstate$RANDOM
export CONTAINER_NAME=tfstate-$ENV_NAME

# Create resource group
az group create -n $TF_RG_NAME -l $TF_RG_LOCATION

# Create storage account
az storage account create -g $TF_RG_NAME -n $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create -n $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

```
