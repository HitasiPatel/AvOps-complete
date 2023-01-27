from xml.dom.minidom import Document
from app.core.schemas.datastreams import (
    DataStreamStatus,
    DataStreamType,
    DataStreamLineage,
)
from pydantic import Field
from typing import List, Optional
from beanie import Document
from uuid import UUID


class DataStream(Document):
    id: str = Field(alias="_id")
    measurementId: str
    name: Optional[str]
    status: DataStreamStatus
    type: DataStreamType
    lineage: DataStreamLineage
    createdAt: Optional[int]
    createdBy: Optional[str]
    tags: Optional[List[dict]] = None
    baseUriPath: str = None
    relativeUriPath: str = None
    test: Optional[bool] = False
