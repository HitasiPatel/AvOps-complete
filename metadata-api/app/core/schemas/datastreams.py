from __future__ import annotations

from enum import Enum
from typing import Dict, List, Optional
from uuid import UUID

from pydantic import BaseModel, Extra, Field


class ProducerMetadata(BaseModel):
    class Config:
        extra = Extra.forbid

    name: str = Field(None, description="Name of the DataStream Producer")
    type: str = Field(
        None, description="Type of the Data Produced", example="measurement"
    )
    version: str = Field(None, description="Version of the DataStream Producer")
    additionalProperties: Optional[Dict[str, str]] = Field(
        None, description="The DataStream's additional metadata"
    )


class DataStreamStatus(Enum):
    CREATED = "CREATED"
    PROCESSING = "PROCESSING"
    COMPLETED = "COMPLETED"
    FAILED = "FAILED"


class DataStreamType(Enum):
    RAW = "RAW"
    EXTRACTED = "EXTRACTED"
    DERIVED = "DERIVED"
    ANNOTATED = "ANNOTATED"
    CURATED = "CURATED"
    SYNCHRONIZED = "SYNCHRONIZED"


class DataStreamPatchRequest(BaseModel):
    class Config:
        extra = Extra.forbid

    status: Optional[DataStreamStatus] = Field(
        None, description="The DataStream status"
    )
    tags: Optional[List[dict]] = Field(None, description="The DataStream's list of tags")


class DataStreamLineage(BaseModel):
    class Config:
        extra = Extra.forbid

    producerMetadata: ProducerMetadata = Field(
        None, description="The data stream lineage information specified upon creation"
    )
    sources: List[str] = Field(
        None, description="The data stream's source dataStream IDs"
    )


class DataStreamRequest(BaseModel):
    name: Optional[str] = Field(None, description="Name of the DataStream")
    type: DataStreamType = Field(description="The DataStream type")
    lineage: DataStreamLineage = Field(
        None, description="The data stream lineage information"
    )
    tags: Optional[List[dict]] = Field(None, description="The DataStream's list of tags")


class DataStreamResponse(BaseModel):
    id: str = Field(description="A datastream's unique identifier", alias="_id")

    measurementId: str = Field(
        description="ID of the measurement the DataStream is under"
    )
    name: Optional[str] = Field(None, description="Name of the DataStream")
    lineage: DataStreamLineage = Field(None, description="The DataStream Lineage")
    type: DataStreamType = Field(None, description="The DataStream type")
    status: DataStreamStatus = Field(description="The DataStream status")
    baseUriPath: str = Field(description="Base Storage Account Path")
    relativeUriPath: str = Field(description="Relative Path of the storage Location")
    tags: Optional[List[dict]] = Field(None, description="The DataStream list of tags")
    createdAt: Optional[int]
    createdBy: Optional[str]
    
    class Config:
        allow_population_by_field_name = True


class DataStreamListResponse(BaseModel):
    class Config:
        extra = Extra.forbid

    size: Optional[int] = Field(None, description="Size of the DataStreams Array")
    items: Optional[List[DataStreamResponse]] = Field(
        None, description="The list of DataStreams"
    )

class LineageResponse(BaseModel):
    id: str = Field(alias="_id")
    depth: int
    lineage: DataStreamLineage


class LineageAggregateResponse(BaseModel):
    lineageSources: List[LineageResponse]
