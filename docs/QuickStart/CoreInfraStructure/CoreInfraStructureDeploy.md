# Deploy the Core Infrastructure

1. ## [Setting Up the Terraform Backend](../../../core-infrastructure/terraform/root/README.md)

2. ## Setting Up the Infrastructure CD

    ### Prerequisites
       * Set the required secrets in azure devops
            1. appId - Service Principal app ID.
            2. password - Service Principal password
            3. tenant - Service Principal tenant ID
            4. subscription - Subscription ID of your Azure subscription
            5. TF_STORAGE_ACCOUNT_KEY - Access Key of your azure storage account that you have configured as your terraform remote backend. 

        Note: [Click-Here](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/set-secret-variables?view=azure-devops&tabs=yaml%2Cbash) to know How to setup the secrets in azure devops

    ### Pipeline steps

        1. Go to your Azure devops project (https://dev.azure.com/<ORG_NAME>/<PROJECT_NAME>) in your favorite browser.

        2. Navigate to the Pipelines option in Azure Devops from the left menu options.

        3. Click the pipeline named `avops-dataops-foundation-iac-cd`.

        4. Click the blue colored Run Pipeline Option on the top right of the browser page.

        5. Select your branch name, Environment and hit the blue Run button in the down right corner of the browser

        6. Now relax and grab a cup a coffee and be right back at the pipeline run after 10-15 minutes. Check the status, if it's failed, go to the Troubleshooting steps as linked at the end of this page.

## [Next Steps: Deploy MetaDataAPI API](../MetaDataAPI/MetaDataAPIDeploy.md)

## [TrobuleShooting](TroubleShooting.md)