# AVOps DataOps Solution Starter Kit

This solution kit is to setup a DataOps solution to process data collected at the vehicle for use in Autonomous Vehicle Operations (AVOps).
We have provided sample data pipelines built using ADLS Gen 2, ADF, Azure Batch, Cosmos DB and App Service to process ROS 2 files.
You can use this code to get started with your own data pipelines.

## Quick Start

Below steps will help you to quickly deploy the avops solution in your azure subscription.

* [Deploy the Infra](docs/QuickStart/CoreInfraStructure/CoreInfraStructureDeploy.md)
* [Deploy the MetaData API](docs/QuickStart/MetaDataAPI/MetaDataAPIDeploy.md)
* [Deploy the ADF Pipelines](docs/QuickStart/ADFPipelines/ADFPipelinesDeploy.md)

## Solution Overview

* [Architecture](docs/architecture.md)
* [Data Pipelines](docs/data-pipelines.md)
* [Data Discovery](docs/data-discovery.md)

## Key Concepts

* [Data Model](docs/data-model.md)
* [Continuous Integration and Continuous Deployment](docs/ci-cd.md)
* [Infrastructure as Code](docs/iac.md)
* [Observability](docs/observability.md)

## Innerloop

* [DevContainer](#devcontainer)
* [Local](#local-machine)
* [Run the Application Locally](#run-the-application-locally)
* [Known Issues, Limitations and Workarounds](#known-issues-limitations-and-workarounds)

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

## Run the Application Locally

Refer the [QuickStart](#getting-started) section

## Built With

* Python - The programming language used
* Terraform - Infrastructure as Code language

## Contributing

## Versioning

We use SemVer for versioning. For the versions available, see the tags on this repository.

## Acknowledgments

Check the list of the contributors [here](https://chrysalis.microsoft.com/assets/avops-dataops-foundation-data-management-for-autonomous-driving)

## Known Issues, Limitations and Workarounds

ToDo
