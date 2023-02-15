from rosbags.rosbag2 import Reader
from rosbags.serde import deserialize_cdr
import cv2
import argparse
import os
from os import path
from cv_bridge import CvBridge
import logging
import logging.config

"""Logger variables section"""
log_file_path = path.join(path.dirname(
    path.abspath(__file__)), 'logging.conf')
logging.config.fileConfig(log_file_path, disable_existing_loggers=False)
log = logging.getLogger(__name__)

"""The encoding to be configured as per the ros2 standard being used"""
encoding ='bayer_rggb8'

"""Images will be saved in PNG format"""
pngExtension ='.png'

bridge = CvBridge()

""" Extracts the images from the rosbag2 file and saves them in the specified output path """
def extractImagesFromRos2File(args):

    """Create output folder if it doesn't exist"""
    if(not os.path.exists(args.outputpath)):
        log.info("Output path doesn't exist- creating it - "+args.outputpath)
        os.makedirs(args.outputpath)

    """Count to track and name the images as and when they are extracted"""
    count = 0
    with Reader(args.inputpath) as reader:
        for connection, timestamp, rawdata in reader.messages():
            msg = deserialize_cdr(rawdata, connection.msgtype)
            """The param msgtype is expected to be of image type"""
            if(connection.msgtype == args.msgtype):
                cv_img = bridge.imgmsg_to_cv2(msg, )
                name = os.path.join(args.outputpath,str(count)+pngExtension)
                log.info("File "+str(count))
                log.info("Image name with path- "+name)
                if not cv2.imwrite(name, cv_img):
                    raise Exception("Could not write image. cv2.imwrite failed !")
                count+=1

if __name__ == '__main__':
    try:

        parser = argparse.ArgumentParser()
        parser.add_argument("--measurementId", "-msid", help="Set the measurement Id")
        parser.add_argument(
            "--dataStreamId", "-dsid", help="Set the datastream Id"
        )
        parser.add_argument("--inputpath", "-ipath",
                            help="Set the file path for the raw bag file")
        parser.add_argument("--outputpath", "-opath",
                            help="Set the file path for the extracted file")
        parser.add_argument("--msgtype", "-mtype",
                            help="Set the api url")
        parser.add_argument("--apibaseurl", "-api",
                            help="Set the api url")
        args = parser.parse_args()
        log.info(args)
        extractImagesFromRos2File(args)
    except Exception as e:
        log.error(str(e))
        raise RuntimeError(f"Error: {e.__class__}\n Error Extracting the Bag File!")