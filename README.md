# AVOps DataOps Solution Starter Kit 

This solution kit is to setup a DataOps solution to process data collected at the vehicle for use in Autonomous Vehicle Operations (AVOps).
We have provided sample data pipelines built using ADLS Gen 2, ADF, Azure Batch, Cosmos DB and App Service to process ROS 2 files.
You can use this code to get started with your own data pipelines.

## Solution Overview
* [Architecture](docs/architecture.md)
* [Data Pipelines](docs/data-pipelines.md)
* [Data Discovery](docs/data-discovery.md)
* [Technologies used](docs/tech-used.md)

## Key Concepts
* [Data Model](docs/data-model.md)
* [Continuous Integration and Continuous Deployment](docs/ci-cd.md)
* [Infrastructure as Code](docs/iac.md)
* [Observability](docs/observability.md)

## Getting Started
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Run the Application Locally](#run-the-application-locally)
* [Deployment](#deployment)
* [Known Issues, Limitations and Workarounds](#issues)

# Getting Started

## Prerequisites
## Installation

`pip install -r requirements.txt` - To Install all the necesarry dependancies

The solution uses pre-commit framework for managing and maintaining multilingual pre-commit hooks, more [here](https://pre-commit.com/). Some of precommit checks included are  `check-yaml, check-added-large-files,end-of-file-fixer, check-merge-conflict,Detect-secrets` check the [pre-commit-config](.pre-commit-config.yaml) file.

`pre-commit install --hook-type commit-msg`

## Run the Application Locally
ToDo:
### Build and Test
TODO: Describe and show how to build your code and run the tests. 
## Deployment
Add additional notes about how to deploy this on a live system.
## Built With
- Python - The programming language used
- Terraform - Infrastructure as Code language
## Contributing
ToDo:

## Versioning
We use SemVer for versioning. For the versions available, see the tags on this repository.

## Acknowledgments
ToDo:

## Inspiration
ToDo:
