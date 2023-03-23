# AVOps DataOps Solution Starter Kit

This solution kit is to setup a DataOps solution to process data collected at the vehicle for use in [Autonomous Vehicle Operations (AVOps)](https://www.microsoft.com/en-us/industry/blog/automotive/2023/01/05/microsoft-automotive-mobility-and-transportation-reference-architectures-rapidly-deploy-solutions-to-drive-your-transformation/).

We have provided sample data pipelines built using [ADLS Gen 2](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction), [ADF](https://learn.microsoft.com/en-us/azure/data-factory/introduction), [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview), [Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction) and [App Service](https://azure.microsoft.com/en-us/products/app-service/) to process [ROS 2](https://docs.ros.org/en/foxy/index.html) files. You can use this code to get started with your own data pipelines.

---

## Quick Start

Below steps will help you to quickly deploy the AVOps solution in your azure subscription.

* [Deploy the Infra](docs/QuickStart/CoreInfraStructure/CoreInfraStructureDeploy.md)
* [Deploy the MetaData API](docs/QuickStart/MetaDataAPI/MetaDataAPIDeploy.md)
* [Deploy the ADF Pipelines](docs/QuickStart/ADFPipelines/ADFPipelinesDeploy.md)
* [Deploy the Image Processor](docs/QuickStart/ImageProcessor/ImageProcessorDeploy.md)
* [Deploy the Batch Orchestrator](docs/QuickStart/BatchOrchestrator/BatchOrchestrator.md)

## Solution Overview

* [Architecture](docs/architecture.md)
* [Data Model](docs/data-model.md)
* [Network Design](docs/network-design.md)
* [Data Pipelines](docs/data-pipelines.md)
* [Data Discovery](docs/data-discovery.md)
* [Continuous Integration and Continuous Deployment](docs/ci-cd.md)
* [Productionisation Recommendations](#productionisation-recommendations)

## Demo/Walkthrough of the Solution Kit pipelines --> [Demo the solution](docs/demo.md)

---

## Delete the Solution

[Refer this section](docs/QuickStart/CoreInfraStructure/CoreInfraStructureDeploy.md#clean-up)

## Getting Started

1. Fork/clone this repository
2. Open VsCode and choose DevContainer (Recommended) or Local Machine to get started with the solution

### DevContainer (Preferred)

#### DevContainer Prerequisites

* Azure subscription with Owner role
* [Docker](https://docs.docker.com/desktop/install/mac-install/)
* [VsCode](https://code.visualstudio.com/download)

A Development Container (or Dev Container for short) allows you to use a container as a full-featured development environment. More about the dev container [here](https://containers.dev/), we highly recommend using .devcontainer for better and efficient developer experience.

The solution includes `.devcontainer` file [here](.devcontainer/devcontainer.json), which included all the pre-requisites necessary for getting started with the solution. Open VsCode and open the solution folder in container.

![VsCode DevContainer](https://code.visualstudio.com/assets/docs/devcontainers/tutorial/dev-containers-commands.png)

**Note:** The very first run might take up-to 7-10 minutes to download all the docker images and the dependencies depending upon the internet speed. Once its loaded, you are good to go!

There are also `.devcontainer` file in the respective modules, open devcontainer from respective folders in vscode to load them with the pre-requisites.

### Local Machine

#### Local Prerequisites

* Azure subscription with Owner role
* [Docker](https://docs.docker.com/desktop/install/mac-install/)
* [VsCode](https://code.visualstudio.com/download)
* Python
* AZ CLI
* Git
* pip

`pip install -r requirements.txt` - To Install all the necessary dependencies

The solution uses pre-commit framework for managing and maintaining multilingual pre-commit hooks, more [here](https://pre-commit.com/). Some of pre-commit checks included are  `check-yaml, check-added-large-files,end-of-file-fixer, check-merge-conflict,Detect-secrets` check the [pre-commit-config](.pre-commit-config.yaml) file.

`pre-commit install --hook-type commit-msg`

## Productionisation Recommendations

This solution kit is a simplified version of a production ready Data Ops platform. If you wish to use this solution in production for a customer, you might want to make a few additions/changes:

* In the solution kit, the metadata API is deployed in Azure App service with containers. When going to production, we recommend to use the [compute workloads](https://learn.microsoft.com/en-us/azure/architecture/guide/technology-choices/compute-decision-tree) as per your current infrastructure ex: Azure Kubernetes Service (AKS).
* Azure App service is using the Cosmos DB connection string in the app configuration. It should be moved to the Azure Key Vault.
* Consider implementing API security.
* The nodes in the Azure Batch execution and orchestrator pools have VM configuration which will not be able to scale for large workloads. You will need to use SKUs with appropriate VM sizes as per your workload.
* Azure Batch Orchestrator application is accessing environment variables from .env file. Consider moving these variables to Azure Key Vault.
* Azure Batch Orchestrator application is using SAS keys to access storage accounts. This needs to be changed to Managed Identity.
* Take a look at the auto scaling formula for the Azure Batch execution pool and adjust it as per your workload.
* Currently, certain resources like the Azure Batch Storage, Azure Container Registry and Terraform state storage in the solution kit are public. Additional detail [here](docs/network-design.md). Please ensure to make it private before going to production.


## Contributing

To contribute to this solution kit, please pick a work item from the [backlog](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_backlogs/backlog/AVOps/Features) on Azure Devops and get started.

## Acknowledgments

Check the list of the contributors [here](https://chrysalis.microsoft.com/assets/avops-dataops-foundation-data-management-for-autonomous-driving)
