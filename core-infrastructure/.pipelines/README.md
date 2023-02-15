# avops-dataops-foundation-iac-cd

The IaC CD pipeline enables the automatic deployment of your infrastructure.This pipeline supports the deployment of terraform scripts. 

## Prerequisites 

1. Set the required secrets - The CD pipeline uses some secrets that need to be set before running the pipeline - 
    1. appId - Service Principal app ID.
    1. password - Service Principal password
    1. tenant - Service Principal tenant ID
    1. subscription - Subscription ID of your Azure subscription
    1. TF_STORAGE_ACCOUNT_KEY - Access Key of your azure storage account that you have configured as your terraform remote backend. 

## Pipeline parameters 

1. **env** - The type of environment you are trying to set up. The pipeline supports two environments - dev and test. You can add more environments by setting up blob containers in your Azure storage account configured as the terraform backend. 

## Pipeline variables 

1. src_dir - this variable defines the path of the root directory where the main terraform file is present
2. TF_RG_NAME - this variable defines the resource group where the terraform backend storage account is present.
3. TF_STORAGE_ACCOUNT - Name of the storage account which is used as a terraform remote backend
4. TF_CONTAINER_NAME - Storage container name where the state files will be stored.

## Pipeline Stages 

1. install_terraform - Installs the latest version of terraform on the host machine. 
2. tf_plan_and_apply - 
    1. Login to azure with the service principal
    1. Set the service principal credentials as environment variables on the host. This is required by terraform to authenticate to the azure portal.
    1. Initialize the terraform modules with the backend configured. 
    1. Validate the terraform scripts
    1. Plan the terraform deployment.
    1. Deploy the modules to the azure portal. 

## Steps to run the pipeline

1. The pipeline has a manual trigger.
2. After all the prerequisites are set up, in the AzDo project go to pipelines and select "avops-dataops-foundation-iac-cd"
3. Click on "Run Pipeline" and select the branch you wish to deploy from and the environment you wish to set up.

![infra-cd](./images/infra-cd.png)

4. Click on "Run" and your pipeline will be triggered. 

