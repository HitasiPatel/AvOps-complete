from email import message
from app.core.schemas.error import ProblemDetails, ErrorDetail
from fastapi import status
from fastapi.encoders import jsonable_encoder
from fastapi.responses import JSONResponse
from starlette.requests import Request
from fastapi.exceptions import RequestValidationError
from fastapi import Request, status
from fastapi.responses import JSONResponse
from logging import getLogger
from starlette.exceptions import HTTPException as StarletteHTTPException

log = getLogger(__name__)


def addExceptionHandler(app):
    @app.exception_handler(StarletteHTTPException)
    async def HTTPExceptionHandler(request, exc):
        return JSONResponse(
            getHttpExceptionPayload(str(exc.detail), exc.status_code),
            status_code=exc.status_code,
        )

    @app.exception_handler(RequestValidationError)
    async def validationExceptionHandler(request: Request, exc: RequestValidationError):
        return JSONResponse(
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            content=getRequestValidationPayload(exc=exc),
        )

    @app.exception_handler(Exception)
    async def exceptionHandler(request, err):
        baseErrorMessage = f"Failed to execute: {request.method}: {request.url}"
        errorDetails = {"message": f"{baseErrorMessage}. Detail: {err}"}
        log.info(errorDetails)
        return JSONResponse(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            content=getUnCatchedExceptionPayload(errorDetails),
        )


def getRequestValidationPayload(exc):
    """_summary_

    Args:
        exc (_type_): _description_

    Returns:
        _type_: _description_
    """
    errorDetails = []
    propertyName = ""
    propertyError = ""
    for error in exc.errors():
        if "loc" in error and len(error["loc"]) >= 1:
            propertyName = error["loc"][1]
        if "msg" in error:
            propertyError = f"{error['msg']} : {error['type']} "
        error_detail = ErrorDetail(
            propertyName=propertyName, propertyError=propertyError
        )
        errorDetails.append(error_detail)

    problemDetails = ProblemDetails(
        code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        description="Request Validation Exception Occcured",
        details=errorDetails,
    )

    return jsonable_encoder(problemDetails)


def getHttpExceptionPayload(errorMessage, statusCode):

    problemDetails = ProblemDetails(code=statusCode, description=errorMessage)
    return jsonable_encoder(problemDetails)


def getUnCatchedExceptionPayload(errorMessage):

    problemDetails = ProblemDetails(
        code=status.HTTP_500_INTERNAL_SERVER_ERROR, description=str(errorMessage)
    )

    return jsonable_encoder(problemDetails)
