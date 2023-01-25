import time
from app.core.models.datastreams import DataStream
from logging import getLogger
from app.core.config import getSettings
from app.core.schemas.datastreams import DataStreamStatus, DataStreamType
from beanie.operators import In
from azure.storage.blob import BlobClient, BlobServiceClient

from app.utils.constants import DATASTREAM_JSON

settings = getSettings()

log = getLogger(__name__)


async def validateDataStreamSources(type, sources):
    if type == DataStreamType.RAW or type == DataStreamType.ANNOTATED:
        if len(sources) > 0:
            return (
                False,
                f"RAW type Datastreams must not include any sources in lineage",
            )
    else:
        if len(sources) < 1:
            return (
                False,
                f"DERIVED/EXTRACTED/ANNOTATED/CURATED/SYNCHRONIZED type Datastreams must have atleast one sources in lineage",
            )
        sourcesFromDb = (
            await DataStream.find(In(DataStream.id, sources))
            .find(DataStream.status == DataStreamStatus.COMPLETED)
            .to_list()
        )
        if len(sources) != len(sourcesFromDb):
            return (False, f"Source Datastream/s are not valid or not completed")

    return (True, "OK")


def getStorageAccountUrl(dataStreamType):
    """Get Configured storage account url for a datastream type

    Args:
        dataStreamType(DataStreamType): DataStream type (RAW/EXTRACTED/DERIVED/ANNOTATED/CURATED/SYNCHRONIZED)

     Returns:
        storageAccountUrl(str): Configured storage account url of the datastream type
    """
    if dataStreamType == DataStreamType.RAW:
        return settings.AZURE_STORAGE_ACCOUNT_RAW_ZONE_URL
    else:
        return settings.AZURE_STORAGE_ACCOUNT_DERIVED_ZONE_URL


def getStorageLocationUris(measurementDoc, datastreamReq, datastreamId):
    """Get Storage location uri for storing datastream data

    Args:
        measurementDoc(Measurement): Mongo measurement Doc
        datastreamReq(DataStreamRequest): DataStream Request
        datastreamId(UUID): Unique Id of the Datastream

     Returns:
        storageAccUrl(str): Datastream's storage account uri
        relativeUrl(str): Datastream's hierarchical uri path
    """
    dataStreamType = datastreamReq["type"]

    vehicleId = measurementDoc.vehicle["id"]
    dateFolderPath = time.strftime("%Y/%m/%d", time.localtime(measurementDoc.createdAt))

    storageAccUrl = getStorageAccountUrl(dataStreamType)
    return (
        f"{storageAccUrl}",
        f"{dataStreamType.value.lower()}/{dateFolderPath}/{vehicleId}/{str(measurementDoc.id)}/{str(datastreamId)}",
    )


def getSearchCriteria(**queryParams):
    """Get Mongo DB Search Criteria for input Query Params

    Args:
        queryParams: variable length query params of type QueryParam nametuple

     Returns:
        searchCriteria: mongo format search criteria for the Documents searching
    """

    searchCriteria = []
    for paramName, param in queryParams.items():
        if param.val:
            searchCriteria.append({paramName: {f"${param.op}": param.val}})

    return searchCriteria


def getLineageAggregateQuery():
    return {
        "$graphLookup": {
            "from": "DataStream",
            "startWith": f"${DataStream.id}",
            "connectFromField": DataStream.lineage.sources,
            "connectToField": DataStream.id,
            "as": "lineageSources",
            "depthField": "depth",
        }
    }


def createManifestFile(datastream: DataStream):
    conn_string = (
        getSettings().AZURE_STORAGE_ACCOUNT_RAW_ZONE_URL_CONNECTION_STRING
        if datastream.type == DataStreamType.RAW
        else getSettings().AZURE_STORAGE_ACCOUNT_DERIVED_ZONE_URL_CONNECTION_STRING
    )
    
    storage_account_key = BlobServiceClient.from_connection_string(
        conn_string
    ).credential.account_key
    
    return BlobClient.from_blob_url(
        "/".join(
            map(
                lambda url: url.strip("/"),
                [datastream.baseUriPath, datastream.relativeUriPath, DATASTREAM_JSON],
            )
        ),
        storage_account_key,
    ).upload_blob(datastream.json(exclude_none=True), overwrite=True)
    