# ADF Pipelines Deploy

## Prerequisites

### Create service connections
- **ARM Service connection** - This is needed to deploy the ADF artifacts. The service connection "arm_service_connection_{env}" already created for MetaDataAPIDeploy can be used to deploy ADF artifacts as well.
* Note: {env} name should be same as used in the Pre-Deploy and Core infra steps.

- **Pipeline variables** - There are a few variables specific to the environments, these can be customized using the variable groups in Azure Devops (https://learn.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml). Go to library in pipelines, and create a adf_{env} varibale group, this group should have authorization to the adf pipeline which can be given using the Pipeline permissions option appearing at the top when a varibale group is open. 
* The following vaules have to be added to the variable group
    1. azure_data_factory_name : Name of your azure data factory instance
    2. azure_service_connection_name : The ARM Service connection name, we have in the previous step
    3. azure_subscription_id : The subscription_id foe the environment
    4. batch_account_name : Name of the storage account to be used in ADF
    5. batch_account_url : Link to the batch storage account
    6. batch_private_ep : Name of the private endpoint to be created for linking batch account to adf
    7. keyvault_name : Name of the keyvault used
    8. resource_group_name : Name of the resource group used
    9. web_app_name : Name of the web app deployed
    10. location : the resource location (eg: West Europe)
    11. LS_AvLanding,LS_AVRaw : Name of the respective linked services

Below steps will deploy the ADF objects through an azure devops pipeline.

1. Go to your Azure devops project (https://dev.azure.com/<ORG_NAME>/<PROJECT_NAME>) in your favorite browser.

2. Navigate to the Pipelines option in Azure Devops from the left menu options.

3. Click the pipeline named `avops-dataops-foundation-adf-ci-cd`.

4. Click the blue colored Run Pipeline Option on the top right of the browser page.

5. Select your branch name, environment and other required parameters and hit the blue Run button in the down right corner of the browser

## [TroubleShooting](TroubleShooting.md)