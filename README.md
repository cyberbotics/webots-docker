# Webots-Docker

## Build

Use the following commands to build the docker container from the Dockerfile:

```
docker build . --file Dockerfile --tag webots-docker:latest
```

## Run Docker container

You can run the previously built image with:
```
docker run webots-docker:latest
```

## Push to Dockerhub

First you have to login:
```
docker login --username=yourhubusername --email=youremail@company.com
```

Check the image ID using:
```
docker images
```

Tag the image:
```
docker tag bb38976d03cf yourhubusername/verse_gapminder:firsttry
```

Push the image to the repository:
```
docker push yourhubusername/verse_gapminder
```
