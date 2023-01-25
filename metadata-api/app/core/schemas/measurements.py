from uuid import UUID
from pydantic import BaseModel, Extra, Field
from typing import Dict, List, Optional


class FileSummary(BaseModel):
    class Config:
        allow_population_by_field_name = True

    id: str = Field(alias="_id")
    filePath: str
    fileName: str
    checksum: str
    createdAt: int


class MeasurementRequest(BaseModel):

    id: str = Field(description="A measurement's unique identifier", alias="_id")
    metadata: Optional[Dict[str, str]] = Field(
        None, description="The data stream's additional metadata"
    )
    vehicle: Optional[dict] = Field(default=None)
    driver: Optional[dict] = Field(default=None)
    createdAt: Optional[int] = Field(None, description="Unix Epochh TimeStamp")
    description: Optional[str] = Field(None, description="Measurement description")
    task: Optional[dict] = Field(default=None)
    files: List[FileSummary]
    tags: Optional[List] = None

    class Config:
        allow_population_by_field_name = True


class MeasurementResponse(BaseModel):
    id: str = Field(description="A measurement's unique identifier", alias="_id")
    metadata: Optional[Dict[str, str]] = Field(
        None, description="The data stream's additional metadata"
    )
    vehicle: Optional[dict] = Field(default=None)
    driver: Optional[dict] = Field(default=None)
    createdAt: Optional[int] = Field(None, description="Unix Epochh TimeStamp")
    description: Optional[str] = Field(None, description="Measurement description")
    task: Optional[dict] = Field(default=None)
    files: List[FileSummary]
    tags: Optional[List] = None

    class Config:
        allow_population_by_field_name = True


class MeasurementListResponse(BaseModel):
    class Config:
        extra = Extra.forbid

    size: Optional[int] = Field(None, description="Size of the Measurements Array")
    items: Optional[List[MeasurementResponse]] = Field(
        None, description="The list of Measurements"
    )

class MeasurementPatchRequest(BaseModel):
    class Config:
        extra = Extra.forbid

    tags: List = Field(None, description="The Measurement's list of tags")
