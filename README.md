# Webots-Docker
[![Dockerhub](https://img.shields.io/docker/automated/cyberbotics/webots.svg)](https://hub.docker.com/r/cyberbotics/webots)
[![Test](https://github.com/cyberbotics/webots-docker/workflows/Test/badge.svg)](https://github.com/cyberbotics/webots-docker/actions?query=workflow%3ATest)
[![Docker Image CI](https://github.com/cyberbotics/webots-docker/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/cyberbotics/webots-docker/actions?query=workflow%3A%22Docker+Image+CI%22)

This repository is used to create a Docker image with Webots already pre-installed.
To use the already available image please follow the [Webots installation instructions](https://cyberbotics.com/doc/guide/installation-procedure#installing-the-docker-image).

## Build the Image

Use the following commands to build the docker container from the Dockerfile:

```
docker build . --file Dockerfile --tag webots:latest [--build-arg BASE_IMAGE=nvidia/cudagl:10.0-devel-ubuntu18.04] [--build-arg WEBOTS_VERSION=R2021a] [--build-arg WEBOTS_PACKAGE_PREFIX=_ubuntu-18.04]
```

## Run a Docker container from the Image

You can run the previously built image with:
```
docker run -it webots:latest /bin/bash
```
