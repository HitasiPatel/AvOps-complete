# Base and release image mcr.microsoft.com/avdataops/ros:noetic to be built locally and tagged accordingly
FROM mcr.microsoft.com/avdataops/ros:noetic as base
WORKDIR /code

FROM base as dependencies
RUN apt-get update \
    && apt-get install -q -y python3-pip \
    && apt-get install -q -y ros-noetic-cv-bridge \
    && apt-get install -q -y python3-opencv

COPY ./requirements.txt /code/
RUN pip3 install --ignore-installed -r requirements.txt

FROM dependencies AS build  
COPY ./app/ /code/

FROM mcr.microsoft.com/avdataops/ros:noetic AS release
WORKDIR /code

# Install app dependencies
COPY --from=dependencies /code/requirements.txt ./
RUN apt-get update \
    && apt-get install -q -y python3-pip \
    && apt-get install -q -y ros-noetic-cv-bridge \
    && apt-get install -q -y python3-opencv
RUN pip3 install --ignore-installed -r requirements.txt

COPY --from=build /code/ ./

SHELL ["/bin/bash", "-c"]
RUN source /opt/ros/noetic/setup.bash
