# avops-dataops-foundation-image-processor-ci

This pipeline automates the integration of the image processor code.

## Prerequisites

1. Run the **avops-dataops-foundation-iac-cd** and set up your environment on Azure. Refer this [document](../../core-infrastructure/.pipelines/README.md) on steps to run the pipeline. 
1. Create service connection - 
    - **Docker Registry** - This service connection is needed to login to the Azure Container Registry and push the image-processor docker image to the registry. Name the service connection `acr_service_connection_{env}`, this is the format in which it is referred in the pipeline. 
Refer this [article](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) for more details and steps to create a service connection.

## Pipeline parameters

The pipeline takes the following inputs on running it via manual trigger. When the pipeline is triggered on merge to the main, it picks up the default values. You can change these default values based on your environment.

1. **env** - Type of the environment you wish to deploy to. Default value is `dev`.

## Pipeline Variables 

1. **src_dir** - Path of the source directory.
2. **app_name** - Name of the application.
3. **image_repository** - Name of the image repository where the docker image of the app will be pushed. 
4. **tags** - Tags to assign to the docker image. The value is set to the build ID. 
5. **acr_service_connection** - Name of the Docker Registry service connection created in the previous step.

## Pipeline Stages 

1. **code_quality_checks** - 
    - **detect_secrets** - The [detect-secrets](https://pypi.org/project/detect-secrets/) plugin is used to run a check on secrets checked in the code. The results are published as pipeline artifacts.

2. **Push_image_to_ACR** - 
    - **Login to ACR** - Login to the Azure Container Registry with the help of the *acr_service_connection* created in the previous steps.
    - **Build Ros base image** - Build the ros:noetic base image that is used as the base and release stages of the image-processor Docker image.
    - **Build and Push to ACR** - Build the image-processor docker image and push to the Azure Container Registry.

## Steps to run the pipeline 

1. The pipeline is automatically triggered when a PR is merged to the main branch, containing changes in the "image-processor/*" folder. 
2. To manually trigger the pipeline go to Pipelines in this AzDo project and select *avops-dataops-foundation-image-processor-ci*. 
3. Click on "Run Pipeline" and fill in the values as asked by the prompt. Click on Run. 
