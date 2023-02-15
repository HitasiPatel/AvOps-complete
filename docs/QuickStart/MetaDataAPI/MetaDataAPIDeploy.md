# MetaData API deploy

## Prerequisites

### Create service connections
- **ARM Service connection** - This is needed to deploy the docker image to App Service. Name the service connection "arm_service_connection_{env}" (environments supported are dev and test), this is the format in which it is referred in the pipeline. 

- **Azure Container Registry(Docker)** - This service connection is needed to login to the Axure Container Registry and push the metadata-api docker image to the registry. Name the service connection "acr_service_connection_{env}" (environments supported are dev and test), this is the format in which it is referred in the pipeline. 

**Note**: Refer this [article](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) for more details and steps to create a service connection.
 
## Pipeline Run

This pipeline pushes the MetaData API docker container in to the ACR and then deploys to a linux web app container in your azure resource group.

1. Go to your Azure devops project (https://dev.azure.com/<ORG_NAME>/<PROJECT_NAME>) in your favorite browser.

2. Navigate to the Pipelines option in Azure Devops from the left menu options.

3. Click the pipeline named `avops-dataops-foundation-metadata-api-ci`.

4. Click the blue colored Run Pipeline Option on the top right of the browser page.

5. Select your branch name, fill up the environment name you selected in the core infra deploy and fill up the other required fields name from the azure portal. Finally, hit the blue Run button in the down right corner of the browser.

## [Next Steps: Deploy ADF Pipelines](../ADFPipelines/ADFPipelinesDeploy.md)

## [Troubleshooting](TroubleShooting.md)
