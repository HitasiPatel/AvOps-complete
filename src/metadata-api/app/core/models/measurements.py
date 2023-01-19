from xml.dom.minidom import Document
from pydantic import Field
from typing import Dict, List, Optional
from beanie import Document
from uuid import UUID
from app.core.schemas.measurements import *
from app.utils.dateUtils import getNowAsIntWithTZ

class Measurement(Document):
    id: str = Field(alias="_id")
    metadata: Optional[Dict[str, str]]
    vehicle: Optional[dict] = Field(default=None)
    driver: Optional[dict] = Field(default=None)
    createdAt: Optional[int] = Field(default = getNowAsIntWithTZ())
    description: Optional[str]
    task: Optional[dict] = Field(default=None)
    files: List[FileSummary]
    tags: Optional[List]
