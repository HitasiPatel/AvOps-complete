# AVOps DataOps Solution Starter Kit

This solution kit is to setup a DataOps solution to process data collected at the vehicle for use in [Autonomous Vehicle Operations (AVOps)](https://www.microsoft.com/en-us/industry/blog/automotive/2023/01/05/microsoft-automotive-mobility-and-transportation-reference-architectures-rapidly-deploy-solutions-to-drive-your-transformation/).

We have provided sample data pipelines built using [ADLS Gen 2](https://learn.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction), [ADF](https://learn.microsoft.com/en-us/azure/data-factory/introduction), [Azure Batch](https://learn.microsoft.com/en-us/azure/batch/batch-technical-overview), [Cosmos DB](https://learn.microsoft.com/en-us/azure/cosmos-db/introduction) and [App Service](https://azure.microsoft.com/en-us/products/app-service/) to process [ROS 2](https://docs.ros.org/en/foxy/index.html) files. You can use this code to get started with your own data pipelines.

---
## Quick Start

Below steps will help you to quickly deploy the avops solution in your azure subscription.

* [Deploy the Infra](docs/QuickStart/CoreInfraStructure/CoreInfraStructureDeploy.md)
* [Deploy the MetaData API](docs/QuickStart/MetaDataAPI/MetaDataAPIDeploy.md)
* [Deploy the ADF Pipelines](docs/QuickStart/ADFPipelines/ADFPipelinesDeploy.md)


## Solution Overview

* [Architecture](docs/architecture.md)
* [Data Model](docs/data-model.md)
* [Data Pipelines](docs/data-pipelines.md)
* [Data Discovery](docs/data-discovery.md)
* [Continuous Integration and Continuous Deployment](docs/ci-cd.md)

---

## Getting Started

1. Fork/clone this repository
2. Open VsCode and choose DevContainer (Recommended) or Local Method to get started with the solution

### DevContainer

#### DevContainer Prerequisites

* VsCode
* Docker

A Development Container (or Dev Container for short) allows you to use a container as a full-featured development environment. More about the dev container [here](https://containers.dev/), we highly recommend using .devcontainer for better and efficient developer experience.

The solution includes `.devcontainer` file [here](.devcontainer/devcontainer.json), which included all the pre-requisites necessary for getting started with the solution. Open VsCode and open the solution folder in container. 

![VsCode DevContainer](https://code.visualstudio.com/assets/docs/devcontainers/tutorial/dev-containers-commands.png)

**Note:** The very first run might take up-to 7-10 minutes to download all the docker images and the dependencies depending upon the internet speed. Once its loaded, you are good to go!

There are also `.devcontainer` file in the respective modules, open devcontainer from respective folders in vscode to load them with the pre-requisites.

### Local Machine

#### Local Prerequisites

* VsCode
* Docker
* Python
* AZ CLI
* Git
* pip

`pip install -r requirements.txt` - To Install all the necessary dependencies

The solution uses pre-commit framework for managing and maintaining multilingual pre-commit hooks, more [here](https://pre-commit.com/). Some of pre-commit checks included are  `check-yaml, check-added-large-files,end-of-file-fixer, check-merge-conflict,Detect-secrets` check the [pre-commit-config](.pre-commit-config.yaml) file.

`pre-commit install --hook-type commit-msg`

## Built With

* Python - The programming language used
* Terraform - Infrastructure as Code language

## Contributing

To contribute to this solution kit, please pick a work item from the [backlog](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_backlogs/backlog/AVOps/Features) on Azure Devops and get started.


## Acknowledgments

Check the list of the contributors [here](https://chrysalis.microsoft.com/assets/avops-dataops-foundation-data-management-for-autonomous-driving)

