# MetaData API deploy

This pipeline pushes the MetaData API docker container in to the ACR and then deploys to a linux web app container in your azure resource group.

1. Go to your Azure devops project (https://dev.azure.com/<ORG_NAME>/<PROJECT_NAME>) in your favorite browser.

2. Navigate to the Pipelines option in Azure Devops from the left menu options.

3. Click the pipeline named `avops-dataops-foundation-metadata-api-ci`.

4. Click the blue colored Run Pipeline Option on the top right of the browser page.

5. Select your branch name, Environment and fill up the required options and hit the blue Run button in the down right corner of the browser.

## [Next Step](../ADFPipelines/ADFPipelinesDeploy.md)

## [TroubleShooting](TrobuleShooting.md)
