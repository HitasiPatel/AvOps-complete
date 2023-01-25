import pytest
from app.tests.test_data.measurement import *
from app.tests.test_data.datastream import *


@pytest.fixture(autouse=True)
def measurementPostValidPayloadBase():
    return measurementPostValidPayloadBaseData


@pytest.fixture(autouse=True)
def measurementPostValidPayload():
    return measurementPostValidPayloadData


@pytest.fixture(autouse=True)
def measurementPostInValidPayloadMissingId():
    return measurementPostInValidPayloadMissingIdData


@pytest.fixture(autouse=True)
def measurementPostInValidPayloadMissingId():
    return measurementPostInValidPayloadMissingIdData


@pytest.fixture(autouse=True)
def measurementPatchValidPayload():
    return measurementPatchValidPayloadData


@pytest.fixture(autouse=True)
def measurementPatchInvalidPayload():
    return measurementPatchInvalidPayloadData


@pytest.fixture(autouse=True)
def measurementId():
    return measurementIdData


@pytest.fixture(autouse=True)
def measurementIdInvalid(autouse=True):
    return measurementIdInvalidData


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadRaw():
    return datastreamPostValidPayloadRawDataRaw


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadExtracted():
    return datastreamPostValidPayloadDataExtracted


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadDerived():
    return datastreamPostValidPayloadDataDerived


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadCurated():
    return datastreamPostValidPayloadDataCurated


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadAnnotated():
    return datastreamPostValidPayloadDataAnnotated

@pytest.fixture(autouse=True)
def datastreamPostValidPayloadAnnotatedWithSources():
    return datastreamPostValidPayloadDataAnnotatedWithSources

@pytest.fixture(autouse=True)
def datastreamPostValidPayloadSynchronized():
    return datastreamPostValidPayloadDataSynchronized


@pytest.fixture(autouse=True)
def datastreamPostValidPayloadBad():
    return datastreamPostValidPayloadDataBad


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadRawDatastream():
    return datastreamPostInValidPayloadRawDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadDerivedDatastream():
    return datastreamPostInValidPayloadDerivedDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadExtractedDatastream():
    return datastreamPostInValidPayloadExtractedDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadCuratedDatastream():
    return datastreamPostInValidPayloadCuratedDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadSynchronizedDatastream():
    return datastreamPostInValidPayloadSynchronizedDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadAnnotatedDatastream():
    return datastreamPostInValidPayloadAnnotatedDatastreamData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadMissingId():
    return datastreamPostInValidPayloadMissingIdData


@pytest.fixture(autouse=True)
def datastreamPostInValidPayloadMissingId():
    return datastreamPostInValidPayloadMissingIdData


@pytest.fixture(autouse=True)
def datastreamPatchValidPayload():
    return datastreamPatchValidPayloadData


@pytest.fixture(autouse=True)
def datastreamId():
    return datastreamIdData


@pytest.fixture(autouse=True)
def measurementPostInValidPayloadMissingVehicleId():
    return measurementPostInValidPayloadMissingVehicleIdData

