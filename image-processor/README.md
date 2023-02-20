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
python3 /app/app.py --measurementId mid --dataStreamId did --inputpath <inputpath> --outputpath <outputpath> --msgtype sensor_msgs/msg/Image --apibaseurl https://avops.dataopos.com/v1/
```

### Runing in Dev Containers

Open VSCode from application folder and a popup will appear in bottom right to Reopen In DevContainers.
Run the app directly from VSCode using Run/Debug Option


### Running in Docker

docker build . -t processor:latest
```
docker run --rm --mount type=bind,source=/Users/name1/Downloads/download1,target=/raw --mount type=bind,source=/Users/name1/Downloads/output,target=/extracted processor:latest bash -c "source /opt/ros/noetic/setup.bash&&python3 /code/app.py --measurementId mid --dataStreamId did --inputpath <inputpath> --outputpath <outputpath> --msgtype sensor_msgs/msg/Image --apibaseurl https://avops.dataopos.com/v1"
```
## Building and deploying Image Processor Manually

Image processor can also be built and deployed using below steps:

* Checkout the Image Processor Code.
* Open terminal and go to image-process directory.
* Login to ACR using terminal. 
* Build the image locally using docker
* Tag the image to the image-processor acr repository.
* Push the locally built image to acr.

The sequence of commands are shown below:

```
az acr login --name <acrName>.azurecr.io
docker build --platform linux/amd64 -t image-processor ./
docker tag image-processor:latest <acrName>.azurecr.io/image-processor
docker push <acrName>.azurecr.io/image-processor
```
* After the image is uploaded, please scale down the execution pool of the batch to zero. This is to ensure that the latest image is used from the next time the nodes are added to that pool.