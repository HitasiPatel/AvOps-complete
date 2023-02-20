# Deploy the Core Infrastructure

## 1. [Setting Up the Terraform Backend](../../../core-infrastructure/terraform/root/README.md)

## 2. Setting Up the Infrastructure CD

### a. Set the below secrets in azure devops
1. appId - Service Principal app ID.
2. password - Service Principal password
3. tenant - Service Principal tenant ID
4. subscription - Subscription ID of your Azure subscription
5. TF_STORAGE_ACCOUNT_KEY - Access Key of your azure storage account that you have configured as your terraform remote backend.

- To set the secerts follow these steps - 
    1. On the AzDo project go to pipelines and select `avops-dataops-foundation-iac-cd`. 
    1. Click on Edit 
    ![edit_pipeline](./../../../core-infrastructure/.pipelines/images/edit_pipeline.png)
    1. Click on Variables. 
    ![pipeline_variable](./../../../core-infrastructure/.pipelines/images/variables.png)
    1. Add the variable name and value and select the box `Keep this value secret`
    ![add_seceret](./../../../core-infrastructure/.pipelines/images/add_seceret.png)
    1. Click on `OK` and the secret will be added. 

### b. Update the terraform vars
* Update the [terraform vars file](../../../core-infrastructure/terraform/root/terraform.tfvars) with the environment variable name you used in the Step 1 (Setting up Terraform backend)

* Note: [Click-Here](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/set-secret-variables?view=azure-devops&tabs=yaml%2Cbash) to know How to setup the secrets in azure devops

### c. Pipeline steps

1. Go to your [Azure devops project](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line) in your favorite browser.

2. Navigate to the Pipelines option in Azure Devops from the left menu options.

3. Click the pipeline named `avops-dataops-foundation-iac-cd`.

4. Click the blue colored Run Pipeline Option on the top right of the browser page.

5. Select your branch name, Environment and hit the blue Run button in the down right corner of the browser.

![iac-cd](./../../../core-infrastructure/.pipelines/images/infra-cd.png)

6. Now relax and grab a cup a coffee and be right back at the pipeline run after 10-15 minutes. Check the status, if it's failed, go to the Troubleshooting steps as linked at the end of this page.

## Core Infrastructure validation
After deploying the solution core infrastructure, make sure to tally with the below image's core azure resources,  if they are existing in your Resource Group.
![azure-resource-viz](../../images/azure-resource-viz.png)

## [Next Steps: Deploy MetaDataAPI](../MetaDataAPI/MetaDataAPIDeploy.md)

## [TroubleShooting](TroubleShooting.md)