from functools import lru_cache
from typing import Optional

from pydantic import BaseSettings


class Settings(BaseSettings):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    APPLICATIONINSIGHTS_CONNECTION_STRING: Optional[str] = None
    APPLICATIONINSIGHTS_ROLENAME: Optional[str] = None
    ENABLE_LOGS_ON_TRACES: Optional[bool] = False
    AZURE_LOG_LEVEL: Optional[str] = "INFO"
    AZURE_LOG_FORMAT: Optional[str] = (
        "%(asctime)s %(levelname)s %(name)s %(filename)s:%(lineno)d traceId=%(traceId)s "
        "spanId=%("
        "spanId)s - %(message)s"
    )
    # export duration in seconds
    AZURE_TRACE_EXPORT_DURATION = 2.0
    AZURE_LOG_EXPORT_DURATION = 1.0
    API_TITLE = "Utility"

    class Config:
        env_file = ".env"


@lru_cache()
def getSettings():
    return Settings()
