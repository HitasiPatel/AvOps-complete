from app.core.models.measurements import Measurement
import pytest
from fastapi.testclient import TestClient
from app.app import app
from app.core.config import getSettings
from mongomock_motor import AsyncMongoMockClient
from beanie import init_beanie
from app.core.models.models import __beanie_models__
from mongomock_motor import AsyncMongoMockClient
from app.app import getSettings

client = TestClient(app=app)
settings = getSettings()

version = settings.VERSION


@pytest.fixture()
async def resource(measurementPostValidPayloadBase):
    app = AsyncMongoMockClient()
    await init_beanie(
        document_models=[Measurement], database=app.get_database(name="contoso")
    )
    response = client.post(
        f"{version}/measurements", json=measurementPostValidPayloadBase
    )


@pytest.mark.asyncio
async def test_createMeasurementWithNoValidationErrors(
    resource, measurementPostValidPayload
):
    await resource
    response = client.post(f"{version}/measurements", json=measurementPostValidPayload)

    assert response.status_code == 201


@pytest.mark.asyncio
async def test_createMeasurementWithMissingId(
    resource, measurementPostInValidPayloadMissingId
):

    await resource
    response = client.post(
        f"{version}/measurements", json=measurementPostInValidPayloadMissingId
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createMeasurementWithMissingVehicleId(
    resource, measurementPostInValidPayloadMissingVehicleId
):

    await resource
    response = client.post(
        f"{version}/measurements", json=measurementPostInValidPayloadMissingVehicleId
    )

    assert response.status_code == 422


@pytest.mark.asyncio
async def test_createMeasurementWithExistingId(
    resource, measurementPostValidPayloadBase
):

    await resource
    response = client.post(
        f"{version}/measurements", json=measurementPostValidPayloadBase
    )

    assert response.status_code == 200


@pytest.mark.asyncio
async def test_getMeasurements(resource):

    await resource
    response = client.get(f"{version}/measurements")
    assert response.status_code == 200
    assert response.json()["size"] == 1


@pytest.mark.asyncio
async def test_getMeasurementsById(resource, measurementId):

    await resource
    response = client.get(f"{version}/measurements/{measurementId}")
    assert response.status_code == 200
    assert response.json()["id"] == measurementId


@pytest.mark.asyncio
async def test_getMeasurementsByWhenMeasurementIdDoesntExist(
    resource, measurementIdInvalid
):

    await resource
    response = client.get(f"{version}/measurements/{measurementIdInvalid}")
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_updateMeasurement(resource, measurementId, measurementPatchValidPayload):

    await resource

    # GET Measurement
    response = client.get(f"{version}/measurements")
    rspBody = response.json()
    measurementId = rspBody["items"][0]["id"]

    # PATCH Measurement
    response = client.patch(
        f"{version}/measurements/{measurementId}", json=measurementPatchValidPayload
    )
    assert response.status_code == 204

    # GET Measurement
    response = client.get(f"{version}/measurements/{measurementId}")
    responseBody = response.json()
    assert responseBody["tags"] == measurementPatchValidPayload["tags"]


@pytest.mark.asyncio
async def test_updateMeasurementWithInvalidPayload(
    resource, measurementId, measurementPatchInvalidPayload
):

    await resource

    # GET Measurement
    response = client.get(f"{version}/measurements")
    rspBody = response.json()
    measurementId = rspBody["items"][0]["id"]

    # PATCH Measurement
    response = client.patch(
        f"{version}/measurements/{measurementId}", json=measurementPatchInvalidPayload
    )
    assert response.status_code == 422
