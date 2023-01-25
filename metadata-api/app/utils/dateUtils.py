from datetime import datetime
from operator import imod
import pytz
from app.utils.constants import *

DEFAULT_TIMEZONE: str = DEFAULT_TIMEZONE


def getNowAsFloatWithTZ(tz=DEFAULT_TIMEZONE) -> float:
    dtime = datetime.now()
    timezone = pytz.timezone(tz)
    dtzone = timezone.localize(dtime)
    return dtzone.timestamp()


def getNowAsIntWithTZ(tz=DEFAULT_TIMEZONE) -> int:
    return int(round(getNowAsFloatWithTZ(tz)))


def getNowAsUtc():
    return datetime.utcnow()
