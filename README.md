# Webots-Docker
[![Dockerhub](https://img.shields.io/docker/automated/cyberbotics/webots.svg)](https://hub.docker.com/r/cyberbotics/webots)
![Test](https://github.com/DavidMansolino/webots-docker/workflows/Test/badge.svg)
![Docker Image CI](https://github.com/DavidMansolino/webots-docker/workflows/Docker%20Image%20CI/badge.svg)

## Build

Use the following commands to build the docker container from the Dockerfile:

```
docker build . --file Dockerfile --tag webots:latest [--build-arg webots-version=R2020b]
```

## Run Docker container

You can run the previously built image with:
```
docker run -it webots:latest /bin/bash
```

## Push Manually to Dockerhub

First you have to login:
```
docker login --username=cyberbotics --email=support@cyberbotics.com
```

Check the image ID using:
```
docker images
```

Tag the image:
```
docker tag bb38976d03cf cyberbotics/webots:latest
```

Push the image to the repository:
```
docker push cyberbotics/webots
```

## Run Docker container from Dockerhub
Get the image:
```
docker pull cyberbotics/webots:latest
```

The run it:
```
docker run -it cyberbotics/webots:latest /bin/bash
```

## Remove a Docker image

Get the ID
```
docker images
```

Remove it:
```
docker rmi -f IMAGE_ID
```

## GPU Accleration

To run GPU accelerated docker images, the `nvidia-docker2` package need to be installed: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#installing-on-ubuntu-and-debian

Enable connections to server X:
```
xhost +local:root > /dev/null 2>&1
```

Run the container:
```
docker run --gpus=all -it -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw cyberbotics/webots:latest /bin/bash
```

Disable connections to server X:
```
xhost -local:root > /dev/null 2>&1
```
