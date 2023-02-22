# Image Processor deploy
 
## Pipeline Run

This pipeline pushes the Rosbag Image Processor docker container in to the Azure Container Registry(ACR).

1. Go to your [Azure devops pipelines](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_build) in your favorite browser.

2. Click the pipeline named `avops-dataops-foundation-image-processor-ci`.

3. Click the blue colored Run Pipeline Option on the top right of the browser page.

4. Select your branch name, fill up the environment name you selected in the core infra deploy and fill up the other required fields name from the azure portal. Finally, hit the blue Run button in the down right corner of the browser.

## Verification of Image Processor 

## [Next Steps: Setup Batch Orchestrator](../BatchOrchestrator/BatchOrchestrator.md)

## Troubleshooting