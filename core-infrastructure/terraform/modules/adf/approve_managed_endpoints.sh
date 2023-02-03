#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace # For debugging

# Validating input parameters
if [ $# -ne 5 ]
then
    echo "Usage: $0 <RESOURCE_GROUP_NAME> <KEY_VAULT_NAME> <APP_SERVICE_NAME> <MPE_KEY_VAULT_NAME> <MPE_APP_SERVICE_NAME"
    exit 1
fi

resource_group_name=$1

# Resource name
keyvault_name=$2
app_service_name=$3

# Managed private endpoint names
mpe_keyvault_name=$4
mpe_app_service_name=$5

# Procedure to approve managed private endpoint
approveManagedPrivateEndpoint () {
    resource_name=$1
    mpe_name=$2
    case $3 in
        "keyvault")
            mpe_type="Microsoft.KeyVault/vaults"
            ;;
        "appservice")
            mpe_type="Microsoft.Web/sites"
            ;;
        *)
            echo >&2 "Invalid endpoint type specified." 
            exit 1
            ;;
    esac

    echo "   Approving managed private endpoint '${mpe_name}' of type '$3'."
    private_endpoint_connection_id=$(az network private-endpoint-connection list \
        -g "${resource_group_name}" \
        -n "${resource_name}" \
        --type "${mpe_type}" \
        --query "[?contains(properties.privateEndpoint.id,'${mpe_name}') && properties.privateLinkServiceConnectionState.status == 'Pending'].id" \
        --only-show-errors \
        -o tsv)

    if [ -z "${private_endpoint_connection_id}" ]
    then
        echo "   Endpoint already approved."
    else
        az network private-endpoint-connection approve \
            --id "${private_endpoint_connection_id}" \
            --description "Approved" \
            --output none
    fi
}

# Approving managed private endpoints.
echo "Approving managed private endpoints."
approveManagedPrivateEndpoint "${keyvault_name}" "${mpe_keyvault_name}" "keyvault"
approveManagedPrivateEndpoint "${app_service_name}" "${mpe_app_service_name}" "appservice"