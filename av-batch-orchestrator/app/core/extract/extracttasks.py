"""Task configuration for creating container workloads.
"""
from core.config import Settings, getSettings


def getTaskDefinitions(settings: Settings = getSettings()) -> list:
    """Creates a map of extraction tasks required for a measurement.

    Returns:
        list: A list of task definitions.
    """
    return [
        {
            "name": "ExtractCameraDataTask",
            "imageName": f"{settings.CAMERA_PROCESSOR_IMAGE}",
            "command": "python3 /code/app.py --msid ##MID## --dsid ##DID## --inputpath ##INPUTFILE## --outputpath ##OUTPUTPATH## --msgtype sensor_msgs/Image --apibaseurl ##APIBASEURL##",
            "taskSlotsRequired": 2,
        }
    ]
