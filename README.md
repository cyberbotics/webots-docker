# Webots-Docker

## Build

Use the following commands to build the docker container from the Dockerfile:

```
docker build . --file Dockerfile --tag webots:latest
```

## Run Docker container

You can run the previously built image with:
```
docker run -it webots:latest /bin/bash
```

## Push to Dockerhub

First you have to login:
```
docker login --username=davidmansolino --email=youremail@company.com
```

Check the image ID using:
```
docker images
```

Tag the image:
```
docker tag bb38976d03cf davidmansolino/webots:latest
```

Push the image to the repository:
```
docker push davidmansolino/webots
```

## Run Docker container from Dockerhub
Get the image:
```
docker pull davidmansolino/webots:latest
```

The run it:
```
docker run -it davidmansolino/webots:latest /bin/bash
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

Install the following package:
```
nvidia-container-toolkit
```

Enable connections to server X:
```
xhost +local:root > /dev/null 2>&1
```

Run the container:
```
docker run --gpus=all -it --privileged -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw --net=host webots:latest /bin/bash
```

Disable connections to server X:
```
xhost -local:root > /dev/null 2>&11
```
