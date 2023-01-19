from app.core.models.datastreams import DataStream
from app.core.models.measurements import Measurement
import pytest
from fastapi.testclient import TestClient
from app.app import app
from mongomock_motor import AsyncMongoMockClient
from beanie import init_beanie
from app.core.models.models import __beanie_models__
from mongomock_motor import AsyncMongoMockClient
from app.core.schemas.datastreams import DataStreamType, LineageResponse
from logging import getLogger
from azure.storage.blob import BlobClient, BlobServiceClient

from app.core.config import getSettings

log = getLogger(__name__)

client = TestClient(app=app)
settings = getSettings()
version = settings.VERSION


@pytest.fixture()
async def resource(
    measurementPostValidPayloadBase,
    datastreamPostValidPayloadRaw,
    measurementId,
    mocker,
):
    app = AsyncMongoMockClient()

    await init_beanie(
        document_models=[Measurement], database=app.get_database(name="contoso")
    )
    await init_beanie(
        document_models=[DataStream], database=app.get_database(name="contoso")
    )
    mocker.patch("azure.storage.blob.BlobClient.upload_blob")
    mocker.patch("azure.storage.blob.BlobServiceClient.from_connection_string")
    response = client.post(
        f"{version}/measurements", json=measurementPostValidPayloadBase
    )
    datastreamPostValidPayloadRaw["lineage"]["sources"] = []
    datastreamPostValidPayloadRaw["type"] = DataStreamType.RAW.name
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadRaw,
    )
    client.patch(
        f"{version}/measurements/{measurementId}/datastreams/{response.json()['id']}",
        json={"status": "COMPLETED"},
    )
    return response


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsRaw(
    resource, measurementId, datastreamPostValidPayloadRaw
):
    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadRaw,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsCurated(
    resource, measurementId, datastreamPostValidPayloadCurated
):
    response = await resource
    datastreamPostValidPayloadCurated["lineage"]["sources"] = [response.json()["id"]]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadCurated,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsExtracted(
    resource, measurementId, datastreamPostValidPayloadExtracted
):
    response = await resource
    datastreamPostValidPayloadExtracted["lineage"]["sources"] = [response.json()["id"]]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadExtracted,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsDerived(
    resource, measurementId, datastreamPostValidPayloadDerived
):
    response = await resource
    datastreamPostValidPayloadDerived["lineage"]["sources"] = [response.json()["id"]]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadDerived,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsAnnotated(
    resource, measurementId, datastreamPostValidPayloadAnnotated
):
    response = await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadAnnotated,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithValidationErrorsAnnotated(
    resource, measurementId, datastreamPostValidPayloadAnnotatedWithSources
):
    response = await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadAnnotatedWithSources,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsSynchronized(
    resource, measurementId, datastreamPostValidPayloadSynchronized
):
    response = await resource
    datastreamPostValidPayloadSynchronized["lineage"]["sources"] = [
        response.json()["id"]
    ]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadSynchronized,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsSynchronized(
    resource, measurementId, datastreamPostValidPayloadSynchronized
):
    response = await resource
    datastreamPostValidPayloadSynchronized["lineage"]["sources"] = [
        response.json()["id"]
    ]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadSynchronized,
    )

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createdatastreamWithNoValidationErrorsWrongStatus(
    resource, measurementId, datastreamPostValidPayloadBad
):
    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadBad,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createRawDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadDerivedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadDerivedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createExtractedDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadExtractedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadExtractedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createCuratedDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadCuratedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadCuratedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createAnnotatedDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadAnnotatedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadAnnotatedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createSynchronizedDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadSynchronizedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadSynchronizedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createDerivedDatastreamWithInvalidSources(
    resource, measurementId, datastreamPostInValidPayloadDerivedDatastream
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadDerivedDatastream,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createdatastreamWithMissingId(
    resource, measurementId, datastreamPostInValidPayloadMissingId
):

    await resource
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostInValidPayloadMissingId,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createdatastreamWithInvalidMeasurementId(
    resource, measurementId, datastreamPostValidPayloadRaw
):

    await resource
    measurementId = "a22f3f0e-4fee-45ce-992d-556584ecc5a1"
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadRaw,
    )

    assert response.status_code == 404


@pytest.mark.asyncio
async def test_getdatastreams(resource):

    await resource
    response = client.get(f"{version}/datastreams")
    assert response.status_code == 200
    assert response.json()["size"] == 1


@pytest.mark.asyncio
async def test_getdatastreamsById(resource):

    await resource

    # GET DataStream
    response = client.get(f"{version}/datastreams")
    rspBody = response.json()
    datastreamId = rspBody["items"][0]["id"]

    # GET DataStream By ID
    response = client.get(f"{version}/datastreams/{datastreamId}")
    assert response.status_code == 200
    assert response.json()["id"] == datastreamId


@pytest.mark.asyncio
async def test_updateDatastream(
    resource, measurementId, datastreamId, datastreamPatchValidPayload
):

    await resource

    # GET DataStream
    response = client.get(f"{version}/datastreams")
    rspBody = response.json()
    datastreamId = rspBody["items"][0]["id"]

    # PATCH Datastream
    response = client.patch(
        f"{version}/measurements/{measurementId}/datastreams/{datastreamId}",
        json=datastreamPatchValidPayload,
    )
    assert response.status_code == 204


@pytest.mark.asyncio
async def test_getdatastreamsByIdInvalid(resource, datastreamId):

    await resource

    # GET DataStream By ID
    response = client.get(f"{version}/datastreams/{datastreamId}")
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_getLineageByDatastreamIdWithInvalidId(
    resource, measurementId, datastreamId
):
    await resource
    getLineageResponse = client.get(f"{version}/getlineage/{datastreamId}")
    assert getLineageResponse.status_code == 404


@pytest.mark.asyncio
async def test_getLineageByDatastreamID(
    resource, measurementId, datastreamPostValidPayloadRaw
):
    response = await resource
    client.patch(
        f"{version}/measurements/{measurementId}/datastreams/{response.json()['id']}",
        json={"status": "COMPLETED"},
    )

    datastreamPostValidPayloadRaw["lineage"]["sources"] = [response.json()["id"]]
    datastreamPostValidPayloadRaw["type"] = DataStreamType.DERIVED.name

    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadRaw,
    )
    getLineageResponse = client.get(
        f"{version}/datastreams/lineage/{response.json()['id']}"
    )

    assert getLineageResponse.status_code == 200

    assert len(getLineageResponse.json()) == 1

    assert getLineageResponse.json() == sorted(
        getLineageResponse.json(), key=lambda i: i["depth"]
    )


@pytest.mark.asyncio
async def test_getLineageByDatastreamIdDifferentGraphs(
    resource, measurementId, datastreamPostValidPayloadRaw
):
    response = await resource
    client.patch(
        f"{version}/measurements/{measurementId}/datastreams/{response.json()['id']}",
        json={"status": "COMPLETED"},
    )

    datastreamPostValidPayloadRaw["lineage"]["sources"] = [response.json()["id"]]
    datastreamPostValidPayloadRaw["type"] = DataStreamType.CURATED.name
    url = f"{version}/measurements/{measurementId}/datastreams"

    responseForFistId = client.post(url, json=datastreamPostValidPayloadRaw)
    client.patch(
        f"{url}/{responseForFistId.json()['id']}", json={"status": "COMPLETED"}
    )
    responseForSecondId = client.post(url, json=datastreamPostValidPayloadRaw)
    client.patch(
        f"{url}/{responseForSecondId.json()['id']}", json={"status": "COMPLETED"}
    )

    datastreamPostValidPayloadRaw["lineage"]["sources"] = [
        responseForFistId.json()["id"],
        responseForSecondId.json()["id"],
    ]

    response = client.post(url, json=datastreamPostValidPayloadRaw)

    getLineageResponse = client.get(
        f"{version}/datastreams/lineage/{response.json()['id']}"
    )

    assert getLineageResponse.status_code == 200

    assert len(getLineageResponse.json()) == 1

    assert getLineageResponse.json() == sorted(
        getLineageResponse.json(), key=lambda i: i["depth"]
    )


@pytest.mark.asyncio
async def test_createdatastreamWithAuthenticityOfSourcesValidationErrors(
    resource, measurementId, datastreamPostValidPayloadCurated
):
    response = await resource

    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadCurated,
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createdatastreamWithDatastreamIsCompletedValidationErrors(
    resource, measurementId, datastreamPostValidPayloadCurated
):
    response = await resource
    client.patch(
        f"{version}/measurements/{measurementId}/datastreams/{response.json()['id']}",
        json={"status": "PROCESSING"},
    )
    datastreamPostValidPayloadCurated["lineage"]["sources"] = [response.json()["id"]]
    response = client.post(
        f"{version}/measurements/{measurementId}/datastreams",
        json=datastreamPostValidPayloadCurated,
    )

    assert response.status_code == 422
