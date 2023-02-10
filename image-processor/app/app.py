from rosbags.rosbag2 import Reader
from rosbags.serde import deserialize_cdr
import cv2
import argparse
from cv_bridge import CvBridge

msgTypeImage = 'sensor_msgs/msg/Image'
encoding ='bayer_rggb8'
bridge = CvBridge()

""" Extracts the images from the rosbag2 file and saves them in the specified path """
def extractImagesFromRos2File(args):
    count = 0
    with Reader(args.rawPath) as reader:
        for connection, timestamp, rawdata in reader.messages():
            msg = deserialize_cdr(rawdata, connection.msgtype)
            if(connection.msgtype == msgTypeImage):
                cv_img = bridge.imgmsg_to_cv2(msg, )
                cv2.imwrite(args.extractedPath+str(count), cv_img)
                count+=1

if __name__ == '__main__':
    try:
        parser = argparse.ArgumentParser()
        parser.add_argument("--rawPath", "-rPath",
                            help="Set the file path for the raw bag file")
        parser.add_argument("--extractedPath", "-ePath",
                            help="Set the file path for the extracted file")
        args = parser.parse_args()
        extractImagesFromRos2File(args)
    except Exception as e:
        raise RuntimeError(f"Error: {e.__class__}\n Error Extracting the Bag File!")