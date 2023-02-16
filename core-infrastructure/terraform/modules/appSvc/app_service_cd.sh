#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace # For debugging

# Validating input parameters
if [ $# -ne 3 ]
then
    echo "Usage: $0 <RESOURCE_GROUP_NAME> <APP_SERVICE_NAME> <AZURE_CONTAINER_REGISTRY_NAME>"
    exit 1
fi

resource_group_name=$1

# Resources name
app_service_name=$2
contianer_registry_name=$3

# Enable CI/CD on App Service Instance
appSvc_ci_cd_url=$(az webapp deployment container config \
    -n "${app_service_name}" \
    -g "${resource_group_name}" \
    --enable-cd true \
    --query CI_CD_URL \
    --output tsv)

# Create webhook in ACR for app service CI/CD url
az acr webhook create \
    -n "appsvcwebhook" \
    -g "${resource_group_name}" \
    --registry "${contianer_registry_name}" \
    --actions push \
    --uri "${appSvc_ci_cd_url}" \
    --output none
