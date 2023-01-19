import json
from typing import List
import uuid
import math
from app.core.models.datastreams import DataStream
from app.core.models.measurements import Measurement
from app.core.schemas.datastreams import (
    DataStreamRequest,
    DataStreamResponse,
    DataStreamListResponse,
    DataStreamPatchRequest,
    DataStreamStatus,
    LineageAggregateResponse,
    LineageResponse,
)
from fastapi import APIRouter, Body, Depends, HTTPException, Response, status
from fastapi import Query
from starlette.requests import Request
from app.utils.constants import *
from logging import getLogger
from app.core.services.datastreams import *
from app.core.services.common import *
from uuid import UUID
from collections import namedtuple
from app.utils.dateUtils import getNowAsIntWithTZ

router = APIRouter()

log = getLogger(__name__)

# This defines a generic way for creating getDatastreams Query Params
QueryParam = namedtuple(QUERY_PARAMETER, [VALUE, OPERATOR])


@router.get(
    "/datastreams",
    response_model=DataStreamListResponse,
    response_model_by_alias=False,
    summary=GET_ALL_DATASTREAMS_ROUTE_SUMMARY,
)
async def getDatastreams(
    size: int = DEFAULT_SIZE,
) -> DataStreamListResponse:
    """Get datastreams

    Returns:
        DataStreamListResponse: _description_
    """
    log.debug(f"Received GET request for getDatastreams")
    datastreams = (
        await DataStream.find()
        .limit(size)
        .to_list()
    )
    return DataStreamListResponse(
        size=len(datastreams), items=datastreams
    )


@router.get(
    "/datastreams/{id}",
    response_model=DataStreamResponse,
    response_model_by_alias=False,
    summary=GET_DATASTREAM_BY_ID_ROUTE_SUMMARY,
)
async def getDatastreamById(id: str) -> DataStreamResponse:
    """Get datastream by id

    Returns:
        DataStreamResponse: _description_
    """
    log.debug(f"Received GET request for get_datastream_by_id for Datastream {id}")

    datastream = await DataStream.get(document_id=id)
    if not datastream:
        log.warning(f"Datastram: {id} not Found.")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"datastream with {id} not found.",
        )

    return datastream


@router.post(
    "/measurements/{measurementId}/datastreams",
    response_model=DataStreamResponse,
    response_model_by_alias=False,
    status_code=status.HTTP_201_CREATED,
    summary=CREATE_DATASTREAM_ROUTE_SUMMARY,
)
async def createDatastream(
    measurementId: str, body: DataStreamRequest, request: Request, response: Response
) -> DataStreamResponse:
    """Creates a new datastream

    Args:
        body (datastreamRequest): _description_
        request (Request): _description_
        response (Response): _description_

    Returns:
        DataStreamResponse: _description_
    """
    log.debug(
        f"Received POST request for createDatastream with PAYLOAD {json.dumps(body.json())}, dict: {body.dict()}"
    )

    measurement = await Measurement.get(document_id=measurementId)
    if not measurement:
        log.warning(f"MeasurementId: {measurementId} not Found.")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Measurement with {measurementId} not found.",
        )

    # Raises exception on improper sources per Datastream Types
    sourcesValid, errorStr = await validateDataStreamSources(
        body.dict()["type"], body.dict()["lineage"]["sources"]
    )

    if not sourcesValid:
        log.warning(errorStr)
        raise HTTPException(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, detail=errorStr
        )

    datastream = DataStream(
        **body.dict(),
        measurementId=measurementId,
        status=DataStreamStatus.CREATED,
        id=str(uuid.uuid4()),
        createdAt=getNowAsIntWithTZ(),
        createdBy=ADMIN,
    )

    log.debug(
        f"Generated unique ID {str(datastream.id)} for the datastream in Measurement {str(measurement.id)} "
    )

    datastream.baseUriPath, datastream.relativeUriPath = getStorageLocationUris(
        measurement, body.dict(), datastream.id
    )
    if not datastream.baseUriPath:
        log.warning(f"Storage account is not configured for type {datastream.type}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Storage account is not configured for type {datastream.type}",
        )

    return await datastream.save()


@router.patch(
    "/measurements/{measurementId}/datastreams/{id}",
    response_model=None,
    response_model_by_alias=False,
    status_code=status.HTTP_204_NO_CONTENT,
    summary=UPDATE_DATASTREAM_ROUTE_SUMMARY,
)
async def updateDatastream(
    measurementId: str,
    id: str,
    body: DataStreamPatchRequest,
    request: Request,
    response: Response,
) -> None:
    """Updates a datastream

    Args:
        body (DataStreamPatchRequest): _description_
        request (Request): _description_
        response (Response): _description_

    Returns: None
    """
    log.debug(
        f"Received PATCH request for updateDatastream with PAYLOAD {json.dumps(body.json())}, dict: {body.dict()}"
    )

    datastream = await DataStream.get(document_id=id)
    if not datastream:
        log.warning(f"Datastram: {id} not Found.")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"datastream with {id} not found.",
        )

    if datastream.measurementId != measurementId:
        log.error(f"Datastream {id} doesn't belong to Measurement {measurementId}")
        raise HTTPException(
            status_code=404,
            detail=f"Datastream {id} doesn't belong to Measurement {measurementId}",
        )
    if body.status == DataStreamStatus.COMPLETED:
        try:
            result = createManifestFile(datastream)
            log.debug(
                f"created datastream json for  Datastream {id} with  {result} response"
            )
        except Exception as e:
            log.error(f"Failed to create datastream json for  Datastream {id} ")
            log.error(e)
            raise HTTPException(
                status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                detail=f"Failed to create datastream json for  Datastream {id}{e} ",
            )
    return await datastream.update(getPatchQuery(body))


@router.get(
    "/datastreams/lineage/{id}",
    response_model_by_alias=False,
    response_model_exclude_none=True,
    response_model=List[LineageResponse],
    summary=GET_LINEAGE_BY_DATASTREAM_ID_ROUTE_SUMMARY,
)
async def getLineageByDatastreamId(id: str) -> List[LineageResponse]:

    log.debug(f"Received GET request for getLineageByDatastreamID for Datastream {id}")
    datastream = await DataStream.get(id)

    if not datastream:
        log.warning(f"Datastram: {id} not Found.")
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"datastream with {id} not found.",
        )

    lineage = (
        await DataStream.find(DataStream.id == id)
        .aggregate(
            [getLineageAggregateQuery()], projection_model=LineageAggregateResponse
        )
        .to_list()
    )[0]

    lineage.lineageSources.sort(key=lambda lineageSource: lineageSource.depth)

    return lineage.lineageSources
