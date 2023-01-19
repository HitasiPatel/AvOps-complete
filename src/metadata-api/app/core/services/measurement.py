from logging import get_logger
from app.core.config import getSettings

settings = getSettings()

log = get_logger(__name__)


def getPatchQuery(patchBody):
    """Form and return Patch query for patching a Measurement.
       Only tags of a Measurement can be patched.

    Args:
        patchBody: Body of the patch request came in PATCH payload

     Returns:
        measurementPatchQuery: mongo format patch Query for updating the measurement document
    """
    patchReq = {k: v for k, v in patchBody.dict().items() if v is not None}
    measurementPatchQuery = {
        "$set": {field: value for field, value in patchReq.items()}
    }
    return measurementPatchQuery
