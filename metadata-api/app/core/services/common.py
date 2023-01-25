import logging
from app.core.config import getSettings

settings = getSettings()

log = logging.getLogger(__name__)


def getPatchQuery(patchBody):
    """Form and return Patch query for patching a  or Datastream.
       Only tags of a Measurement can be patched.
       Only tags and status of a Datastream can be patched.

    Args:
        patchBody: Body of the patch request came in PATCH payload

     Returns:
        patchQuery: mongo format patch Query for updating the measurement or datastream document
    """
    patchReq = {k: v for k, v in patchBody.dict().items() if v is not None}
    patchQuery = {"$set": {field: value for field, value in patchReq.items()}}
    return patchQuery
