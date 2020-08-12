# Webots-Docker

## Build

Use the following commands to build the docker container from the Dockerfile:

```
docker build . --file Dockerfile --tag webots:latest
```

## Run Docker container

You can run the previously built image with:
```
docker run webots:latest
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
docker run davidmansolino/webots:latest
```
