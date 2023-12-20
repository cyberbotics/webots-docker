# Webots-Docker

[![Dockerhub](https://img.shields.io/docker/automated/cyberbotics/webots.svg)](https://hub.docker.com/r/cyberbotics/webots)
[![Test](https://github.com/cyberbotics/webots-docker/workflows/Test/badge.svg)](https://github.com/cyberbotics/webots-docker/actions?query=workflow%3ATest)
[![Docker Image CI](https://github.com/cyberbotics/webots-docker/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/cyberbotics/webots-docker/actions?query=workflow%3A%22Docker+Image+CI%22)

This repository is used to create a Docker image with Webots already pre-installed.
To use the already available image please follow the [Webots installation instructions](https://cyberbotics.com/doc/guide/installation-procedure#installing-the-docker-image).

## Build the Images

Use the following command to build the docker container from the Dockerfile:

### Build with Nvidia

``` bash
docker build . --file dockerfiles/Dockerfile.nvidia --tag cyberbotics/webots:latest --build-arg BASE_IMAGE=nvidia/cuda:11.8.0-base-ubuntu22.04 --build-arg WEBOTS_VERSION=R2023b --build-arg WEBOTS_PACKAGE_PREFIX=_ubuntu-22.04
```

### Build the Webots.Cloud Images

Use the following command to build the docker container from the Dockerfile Webots Cloud:

``` bash
docker build . --file dockerfiles/Dockerfile.cloud --tag cyberbotics/webots.cloud:latest --build-arg BASE_IMAGE=cyberbotics/webots:latest --build-arg WEBOTS_VERSION=R2023b
```

## Run a Docker container from the Image


### Running Webots in Docker with GPU Support

``` bash
docker run --gpus=all -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix cyberbotics/webots:latest webots --stdout --stderr --batch --mode=realtime
```
### Running Webots with GPU in Container

``` bash
docker run --gpus=all -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix cyberbotics/webots:latest /bin/bash
```

### Running Container

``` bash
docker run -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix cyberbotics/webots:latest /bin/bash
```

## Clean the temporary Images

You can run the following command to remove **all** temporary images:

``` bash
docker system prune
```
