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


## ADF Pipelines Creation in a particular RG (Manual Steps, Recommended is above way, the ADF CD Pipeline way)

Below steps will help you create the ADF pipelines in the required Resource group

1. Go to portal.azure.com and select the right subscription and right resource group

2. Go to the resources under the desired resource group and click on the Azure Data Factory

3. Click on the "Launch Studio" to open the ADF studio

4. Prior to the Datasets we need to check the Linked Services are there (which are created by IAC)

5. Next we create the Datasets.

   Step 1 : Go to the ADF studio, click on New Datasets,

   ![Create Datasets](images/createDataset.png)

   Step 2 : There choose ADLS Gen 2

   ![Choose source](images/adf-createdataset-step1.png)

   Step 3 : Then type of Data format, in our case binary or json

   ![Choose data format](images/selectDataFormat.png)

   Step 4 : Go to the Code Repo main branch https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_git/avops-dataops-foundation
   Navigate to adf/dataset and copy the name of the dataset you want to create in the ADF studio


   ![Copy Ds name](images/CopyDSNameFromCodebase.png)

   Step 5  Click on {} icon on the right top 

   ![Json Code View](images/ViewJsonCodeForDataset.png)

   Step 6 : Replace the Code copy paste the json of "DS_SourceMeasurements.json" in the ADF studio and click on save

   ![Json Code replace](images/ReplaceDSCode.png)

 
6. Be careful with the json formatting while pasting 

7. It will not save in case any resource names are different/inaccurate

8. Once save succeeds, create all the Datasets

9. Post that proceed to Pipelines. The first one is avops-dataops-foundation/adf/pipeline/Pipeline_LandingToRaw_SolutionKit.json

10. Copy the name of the Pipeline "Pipeline_LandingToRaw_SolutionKit" and create a new Pipeline. Paste the code json, or override in the new pipeline which you created with same name. Follow the pop-ups for error correction.

11. Once the Datasets and Pipelines are in place, go to the pipeline -- > Parameteres -->apiBaseUrl 

12. Change the web app base url to the one used in the desired Resource group

   ![apiBaseUrl pipeline parameter](images/baseurlForApi.png)

13. Append a '/' after the end of base url

14. Validate the pipeline and run them in debug mode and verify them

15. Next proceed to the "adf/pipeline/Pipeline_RawToExtracted_SolutionKit.json". Copy the json, Go to ADF studfio, create the new pipeline with same name and override the json. Make sure that the LS names are overriden/replaced properly as per the resource group.

16. Once the pipeline gets saved, Go to Trigger --> Add new Trigger, copy json and override and repeat.

   Step 1 :

   ![trigger](images/trigger.png)

   Step 2 : 

   ![trigger new](images/trigger_new.png)

   Step 3 : 

   ![trigger config](images/triggerConfig.png)

