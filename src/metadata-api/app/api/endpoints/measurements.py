from app.core.models.measurements import Measurement
from app.core.schemas.measurements import (
    MeasurementListResponse,
    MeasurementResponse,
    MeasurementRequest,
    MeasurementPatchRequest,
)
from starlette.requests import Request
from fastapi import APIRouter, HTTPException, Response, status
from app.core.services.common import *
from logging import getLogger
from app.utils.constants import *
from app.utils.dateUtils import getNowAsIntWithTZ
import json
import math


router = APIRouter()

log = getLogger(__name__)


@router.post(
    "",
    response_model=MeasurementResponse,
    response_model_by_alias=False,
    status_code=201,
    summary=CREATE_MEASUREMENT_ROUTE_SUMMARY,
)
async def createMeasurement(
    body: MeasurementRequest, request: Request, response: Response
) -> MeasurementResponse:
    """Creates a new Measurement

    Args:
        body (MeasurementRequest): _description_
        request (Request): _description_
        response (Response): _description_

    Returns:
        MeasurementResponse: _description_
    """
    log.debug(
        f"Received POST request for create_measurement with PAYLOAD {json.dumps(body.json())}"
    )

    measurement = await Measurement.get(document_id=str(body.id))
    if measurement:
        log.debug(f"Measurement with Id {body.id} already exists")
        response.status_code = status.HTTP_200_OK
        return measurement
    if "id" not in body.vehicle:
        log.warning(f"Vehicle Id not found in measurementId : {body.id}.")
        raise HTTPException(
            status_code=422,
            detail=f"Vehicle Id not found in measurementId : {body.id}.",
        )
    return await Measurement(**body.dict()).save()


@router.get(
    "",
    response_model=MeasurementListResponse,
    response_model_by_alias=False,
    summary=GET_ALL_MEASUREMENTS_ROUTE_SUMMARY,
)
async def getMeasurements(
    size: int = DEFAULT_SIZE,
) -> MeasurementListResponse:
    """Get Measurements

    Returns:
        List[MeasurementResponse]: _description_
    """
    log.debug(f"Received GET request for All Measurements.")

    measurements = (
        await Measurement.find().
        limit(size)
        .to_list()
    )
    return MeasurementListResponse(
        size=len(measurements), items=measurements
    )


@router.get(
    "/{id}",
    response_model=MeasurementResponse,
    response_model_by_alias=False,
    summary=GET_MEASUREMENT_BY_ID_ROUTE_SUMMARY,
)
async def getMeasurementById(id: str) -> MeasurementResponse:
    """Get Measurement by Id

    Args:
        id (str): _description_

    Raises:
        HTTPException: _description_

    Returns:
        MeasurementResponse: _description_
    """
    log.debug(f"Received GET Request for Measurement By Id for MeasurmentId: {id}")
    measurement = await Measurement.get(document_id=id)
    if not measurement:
        log.warning(f"MeasurementId: {id} not Found.")
        raise HTTPException(status_code=404, detail=f"Measurement with {id} not found.")
    return measurement


@router.patch(
    "/{measurementId}",
    response_model=None,
    response_model_by_alias=False,
    status_code=204,
    summary=UPDATE_MEASUREMENT_TAGS,
)
async def updateMeasurement(
    measurementId: str,
    body: MeasurementPatchRequest,
    request: Request,
    response: Response,
) -> None:
    """Updates a Measurement

    Args:
        body (MeasurementPatchRequest): _description_
        request (Request): _description_
        response (Response): _description_

    Returns: None
    """
    log.debug(
        f"Received PATCH request for updateMeasurement with PAYLOAD {json.dumps(body.json())}, dict: {body.dict()}"
    )

    measurement = await Measurement.get(document_id=measurementId)
    if not measurement:
        log.warning(f"Measurement: {measurementId} not Found.")
        raise HTTPException(
            status_code=404, detail=f"Measurement with {measurementId} not found."
        )

    return await measurement.update(getPatchQuery(body))
