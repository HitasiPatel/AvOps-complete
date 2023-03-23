# Deploy the Core Infrastructure

## Setting up your Azure DevOps deployment 
* The solution kit uses Azure DevOps for running CI/CD pipelines. To deploy this solution in your own Azure DevOps instance, you have to do following steps.
    * Clone [this](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_git/avops-dataops-foundation) repository in your Azure DevOps instance (https://dev.azure.com/<ORG_NAME>/<PROJECT_NAME>).
        * You would require to generate git credentials to clone this repository in your Azure DevOps instance.
    * Import pipelines from [this project](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_build), by following Azure [docs](https://learn.microsoft.com/en-us/azure/devops/pipelines/get-started/clone-import-pipeline?view=azure-devops&tabs=yaml).

## Setup Terraform Backend

Follow the steps in the [terraform setup guide](../../../core-infrastructure/terraform/root/README.md) to get started. Follow the guide through the "Pre-Deployment" section.

## Setup the Infrastructure CD

### Create secrets in Azure DevOps

Once you have run the pre-deployment section in the [terraform setup guide](../../../core-infrastructure/terraform/root/README.md), access the deployment variables.

```bash

# load the deployment variables
source .avdataops-tf.env

# list out the deployment variables
env | grep ARM

```

Now, create each of the following variables as a secret in Azure DevOps. To get the secret value, refer to the output from the command above, match the corresponding deployment variable and note down the value.

| Secret Name | Deployment Variable | Description | 
| ------------- | ------------- | ------------- |
| appId  | `ARM_CLIENT_ID` | Service Principal app ID | 
| password | `ARM_CLIENT_SECRET` | Service Principal password |
| tenant | `ARM_TENANT_ID` | Service Principal tenant ID |
| subscription | `ARM_SUBSCRIPTION_ID` | Subscription ID of your Azure subscription |
| TF_STORAGE_ACCOUNT_KEY | `ARM_ACCESS_KEY` | Access Key of Azure storage account used for the Terraform backend |

To create a secret, follow these steps - 

1. On the Azure DevOps project go to pipelines and select `avops-dataops-foundation-iac-cd`. 
2. Click on Edit
  - ![edit_pipeline](./../../../core-infrastructure/.pipelines/images/edit_pipeline.png)
3. Click on Variables. 
  - ![pipeline_variable](./../../../core-infrastructure/.pipelines/images/variables.png)
4. Add the variable name and value and select the box `Keep this value secret`
  - ![add_seceret](./../../../core-infrastructure/.pipelines/images/add_seceret.png)
5. Click on `OK` and the secret will be added. 

For more information on creating secrets in Azure DevOps, refer to the [documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/set-secret-variables?view=azure-devops&tabs=yaml%2Cbash)

### Optional: Customize terraform deployment values

If you would like to customize the deployment, create a new deployment config file.

* Create a new deployment config file for your environment with naming `<env>.tfvars`
* Update your tfvars file located at this [path](../../../core-infrastructure/terraform/root/) with the `<env>` name. You can reference [test.tfvars](../../../core-infrastructure/terraform/root/test.tfvars) in customizing your own deployment config..

## Run the Infrastructe CD Pipeline

1. Go to the Azure devops project where you have forked this repo in your favorite browser.

2. Navigate to the Pipelines option in Azure Devops from the left menu options.

3. Click the pipeline named `avops-dataops-foundation-iac-cd`.

4. Click the blue colored "Run Pipeline Option" on the top right of the browser page.

5. Select your branch name, environment and hit the "Run" button in the down right corner of the browser.

![iac-cd](./../../../core-infrastructure/.pipelines/images/infra-cd.png)

6. Now relax and grab a cup a coffee and be right back at the pipeline run after 15-20 minutes. Check the status, if it's failed, go to the Troubleshooting steps as linked at the end of this page.

## Core Infrastructure Validation
After deploying the core infrastructure, cross check the resources in the newly deployed resource group to the following image:
![azure-resource-viz](../../images/azure-resource-viz.png)

## [Next Steps: Deploy Metadata API](../MetaDataAPI/MetaDataAPIDeploy.md)

## [Troubleshooting](Troubleshooting.md)