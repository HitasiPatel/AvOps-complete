from xml.etree.ElementTree import VERSION
from xmlrpc.client import Boolean
from pydantic import BaseSettings
from typing import Dict, Optional
from functools import lru_cache
from app.utils.constants import *


class Settings(BaseSettings):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    API_DESCRIPTON = "API for Measurements and DataStreams"
    API_TITLE = "Metadata API "
    VERSION = "/v1"
    AZURE_COSMOS_CONNECTION_STRING: str = ""
    AZURE_COSMOS_DATABASE_NAME: str = ""
    APPLICATIONINSIGHTS_CONNECTION_STRING: Optional[str] = None
    APPLICATIONINSIGHTS_ROLENAME: Optional[str] = APPLICATIONINSIGHTS_ROLENAME
    ENABLE_APPINSIGHTS: Optional[bool] = False
    AZURE_STORAGE_ACCOUNT_RAW_ZONE_URL: str = None
    AZURE_STORAGE_ACCOUNT_DERIVED_ZONE_URL: str = None
    AZURE_STORAGE_ACCOUNT_RAW_ZONE_URL_CONNECTION_STRING: str = None
    AZURE_STORAGE_ACCOUNT_DERIVED_ZONE_URL_CONNECTION_STRING: str = None

    class Config:
        env_file = ".env"


@lru_cache()
def getSettings():
    return Settings()
