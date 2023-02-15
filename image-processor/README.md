# Image Processor

This repo has the source code which extracts images from rosbag2 file. Code is written based on the logic described [here]("https://ternaris.gitlab.io/rosbags/").

# Using the Processor Template

Clone or Download the repository to your Local.
Execute the following command to install depedencies :

```
git config core.hooksPath .githooks
virtualenv --python=/usr/local/bin/python3 venv 
source venv/bin/activate 
pip3 install -r requirements.txt
```

## Running the App

### Inside VSCode

Set up the required dependencies for the processor in local machine
Add code to invoke processor from app.py with required parameters
run app.py directly from VSCode using Run/Debug Option

```
python3 app.py --mid mid --dsid dsid --inputpath <inputpath> --outputpath <outputpath> --msgtype sensor_msgs/Image --apibaseurl https://avops.dataopos.com/v1/
```

### Runing in Dev Containers

Open VSCode from application folder and a popup will appear in bottom right to Reopen In DevContainers.
Run the app directly from VSCode using Run/Debug Option


### Running in Docker

docker build . -t processor:latest
```
docker run --rm --mount type=bind,source=/Users/name1/Downloads/download1,target=/raw --mount type=bind,source=/Users/name1/Downloads/output,target=/extracted processor:latest bash -c "source /opt/ros/noetic/setup.bash&&python3 /code/app.py --msid mid --dsid did --inputfilepath <inputpath> --outputpath <outputpath> --msgtype sensor_msgs/msg/Image"
```