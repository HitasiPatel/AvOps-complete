FROM ros:noetic as base
WORKDIR /code

FROM base as dependencies
RUN apt-get update \
    && apt-get install -q -y python3-pip \
    && apt-get install -q -y ros-noetic-cv-bridge \
    && apt-get install -q -y python3-opencv

COPY ./requirements.txt /code/
RUN pip3 install --ignore-installed -r requirements.txt
