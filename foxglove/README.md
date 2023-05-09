# Foxglove Integration - AVOps DataOps Solution Starter Kit



Foxglove Studio is an open source visualization and debugging tool for your robotics data. It is available in a variety of ways to make development as convenient as possible – it can be run as a standalone desktop app, accessed via your browser, or even self-hosted on your own domain.

---

## Features

#### 1. Fully integrated :

By streamlining user can analyze, debug, and make sense of  robotics data, and spend less time setting up tools, and more time focusing on what robots are doing.

#### 2. Modular and flexible :

Studio provides a rich suite of visualization and debugging panels – from interactive charts and 3D visualizations, to camera images and diagnostics feeds.Extensions API also empowers you to create your own custom panels, tailored to your project's specific needs. You can contribute your extension to our public extensions registry, or search it to install useful extensions contributed by your fellow roboticists.

#### 3. Open source and community-driven :

We can fork and contribute to the code of the tool.


[Fore more](https://foxglove.dev/docs/studio)

---
## File Type Supported 

Foxglove Studio can inspect data via multiple sources – including live and recorded data, ROS and non-ROS connections, as well as local and remote recorded data files.

Foxglove Studio can load local and remote ROS 2 (.db3) files, or connect directly to a running ROS stack using a Rosbridge (WebSockets) or native (TCP) connection.

Since ROS 2 (.db3) files do not contain their message definitions, can be ysed converting them into self-contained MCAP files before loading them into Foxglove Studio, mcap CLI tool with this conversion

---

## Integration with AvOPS

[Pipeline](https://dev.azure.com/chrysalis-innersource/Mobility%20Service%20Line/_git/avops-dataops-foundation?path=/foxglove/.pipelines/ci.yaml) automatically pulls the containerised foxglove docker file from  the public repository and deploy the same in the Azure Container registry. Once the deployment is done same is deployed to webApp.

---

#### Major Components

1. Publicly available Docker file for Foxglove at 

    ghcr.io/foxglove/studio:latest

2. Container Registry
3. Web App 

   https://avopsfoxglovestudio.azurewebsites.net
---
### Manual Deployment 

Apart from pipeline we can also deploy the foxglove instance using below mentioned steps

![Docker](../foxglove/images/\dockerdeployment.png)

---
#### Prerequisites

* Azure subscription with Owner role
* [Docker](https://docs.docker.com/desktop/install/mac-install/)
* AZ CLI
---
## References : 

https://foxglove.dev/docs/studio

https://foxglove.dev/docs/studio/connection/data-sources

https://learn.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-docker-webapp?view=azure-devops&tabs=java%2Cyaml

https://learn.microsoft.com/en-us/azure/app-service/tutorial-custom-container?tabs=azure-cli&pivots=container-linux

