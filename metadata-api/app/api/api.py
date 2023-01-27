from fastapi import APIRouter
from app.api.endpoints import measurements, datastreams
from app.core.config import getSettings

from app.core.config import getSettings

settings = getSettings()


api_router = APIRouter()
api_router.include_router(
    measurements.router,
    prefix="/measurements",
    tags=["measurements"],
)
api_router.include_router(datastreams.router, tags=["datastreams"])
