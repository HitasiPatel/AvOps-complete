import logging.config
from os import path
from logging import getLogger

from app.api.api import api_router

from app.utils.exceptions import addExceptionHandler
from app.core.models.models import __beanie_models__
from app.core.config import getSettings
from app.utils.constants import *
from app.avcloudapicommons.instrumentation.fastapi import FastapiInstrumetator

import motor
from beanie import init_beanie
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware



log_file_path = path.join(path.dirname(path.abspath(__file__)), LOGGING_CONF)
logging.config.fileConfig(log_file_path, disable_existing_loggers=False)


settings = getSettings()


app = FastAPI(
    description=settings.API_DESCRIPTON,
    version=settings.VERSION,
    title=settings.API_TITLE,
    openapi_url=f"{settings.VERSION}/openapi.json",
)

FastapiInstrumetator(app).with_excluded_url("docs").with_tracing().instrument()

addExceptionHandler(app=app)

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
async def startup_event():

    log = getLogger(__name__)
    log.info("Starting the Application Up.")

    log.info("Establishing connection with Cosmos DB.")
    client = motor.motor_asyncio.AsyncIOMotorClient(
        settings.AZURE_COSMOS_CONNECTION_STRING
    )

    await init_beanie(
        database=client[settings.AZURE_COSMOS_DATABASE_NAME],
        document_models=__beanie_models__,
    )


app.include_router(api_router, prefix=settings.VERSION)
