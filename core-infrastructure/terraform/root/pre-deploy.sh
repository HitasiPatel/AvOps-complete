#!/bin/bash

# Parse CLI args
LOCATION="westeurope"
ENV="dev"
while getopts "hl:e:" opt; do
    case ${opt} in
      h ) # process option h
        echo "Usage: pre-deploy [-h] "
        echo "       -h  this help message"
        echo "       -l  <location> "
        echo "       -e  <environment> "        
        exit 1
        ;;
      l ) # process option l
        LOCATION=${OPTARG}
        ;;
      e ) # process option e
        ENV=${OPTARG}
        ;;
      ? ) 
        echo "Usage: pre-deploy -h -l location -e environment"
        exit 1
        ;;
    esac
done

# Check if state file exists
if [ -f ./.avdataops-tf.env ]
then
  if [ "$#" = 0 ] || [ $1 != "-y" ]
  then
    read -p "./.avdataops-tf.env already exists. Do you want to remove? (y/n) " response

    if ! [[ $response =~ [yY] ]]
    then
      echo "Please move or delete ./.avdataops-tf.env and rerun the script."
      exit 1;
    fi
  fi
fi

# Initial verification
export AVOPS_AZ_SUBSCRIPTION_ID=`az account show --query id -o tsv`
if [ ! $AVOPS_AZ_SUBSCRIPTION_ID ]
then
  echo "Currently not signed into AZ CLI. Please sign in and rerun the script."
  exit 1;
fi

if [ ! `az account list-locations -o table --query "[].name" | grep $LOCATION` ]
then
  echo "Location provided is not valid. Please provide an Azure supported location."
  exit 1;
fi

if [ ${#ENV} -gt 4 ]
then
  echo "Please provide an environment name that <= 4 characters. "
  exit 1;
fi

export AVOPS_TF_RG_LOCATION=$LOCATION
export AVOPS_ENV_NAME=$ENV

# Create service principal
export AVOPS_SP_NAME="avdataops-tf-sp"
export AVOPS_SP_CLIENT_ID=`az ad sp list --display-name $AVOPS_SP_NAME -o tsv --query [0].appId`
if [ ! $AVOPS_SP_CLIENT_ID ]
then
  echo "Creating new service principal"
  export AVOPS_SP_CLIENT_ID=`az ad sp create-for-rbac -n $AVOPS_SP_NAME --role="Owner" --scopes="/subscriptions/$AVOPS_AZ_SUBSCRIPTION_ID" --query appId -o tsv`
fi

export AVOPS_SP_CLIENT_SECRET="az ad sp credential reset --id $AVOPS_SP_CLIENT_ID --query password -o tsv 2> /dev/null"
export AVOPS_AZ_TENANT_ID=`az account show --query tenantId -o tsv`

# Initialize Terraform backend storage resources
export AVOPS_TF_RG_NAME=rg-tfstate
export AVOPS_STORAGE_ACCOUNT_NAME=avopstfstate$RANDOM
export AVOPS_CONTAINER_NAME=tfstate-$AVOPS_ENV_NAME

if ! [[ `az group show -n $AVOPS_TF_RG_NAME` ]]
then
  echo "Creating TF backend storage account and resource group"
  az group create -n $AVOPS_TF_RG_NAME -l $AVOPS_TF_RG_LOCATION
  az storage account create -g $AVOPS_TF_RG_NAME -n $AVOPS_STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
fi

export AVOPS_STORAGE_ACCOUNT_NAME=$(az storage account list -g $AVOPS_TF_RG_NAME --query [0].name -o tsv)
export AVOPS_STORAGE_ACCOUNT_KEY='az storage account keys list -g $AVOPS_TF_RG_NAME -n $AVOPS_STORAGE_ACCOUNT_NAME --query "[0].value" -o tsv'

if ! [[  `az storage container show -n $AVOPS_CONTAINER_NAME --account-name $AVOPS_STORAGE_ACCOUNT_NAME 2> /dev/null` ]]
then
  echo "Creating TF backend storage account container"
  az storage container create -n $AVOPS_CONTAINER_NAME --account-name $AVOPS_STORAGE_ACCOUNT_NAME -o none 2> /dev/null
fi

# Set Terraform env variables
export ARM_CLIENT_ID=$AVOPS_SP_CLIENT_ID
export ARM_SUBSCRIPTION_ID=$AVOPS_AZ_SUBSCRIPTION_ID
export ARM_TENANT_ID=$AVOPS_AZ_TENANT_ID

# Save env variable script
echo '#!/bin/bash' > ./.avdataops-tf.env
echo '' >> ./.avdataops-tf.env

IFS=$'\n'

for var in $(env | grep -E 'AVOPS_|ARM_' | sort | sed "s/=/='/g")
do
  echo "export ${var}'" >> ./.avdataops-tf.env
done
echo "export ARM_CLIENT_SECRET=\$($AVOPS_SP_CLIENT_SECRET)" >> ./.avdataops-tf.env
echo "export ARM_ACCESS_KEY=\$($AVOPS_STORAGE_ACCOUNT_KEY)" >> ./.avdataops-tf.env

echo "Pre-deployment complete."
