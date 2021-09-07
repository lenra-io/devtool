# DevTools

## About this repo

This repository provides tooling for testing and debugging Lenra applications. Basically, the devtools can easily launch a Lenra App using the same method as the Lenra Server minus the OpenFaaS and database parts.

It is divided in two parts, the client and the server. The client aims to provide everything necessary to ensure that your app will show correctly using the same standards as the Lenra Client. The server takes care of the communication between the client and the Lenra App.

## Getting started

### Using Docker Hub

We provide a [docker image](https://hub.docker.com/r/lenra/dev-tools) on Docker Hub that you can use, it contains everything you need to unlock the full potential of the DevTools.

### Using local docker

You might not want to use the Docker Hub image, if it is the case you can clone this repository and build the docker images following these instructions :

 - Build for Flutter web
```bash
dev-tools/client/$ flutter build web
```
- Build server Dockerfile
```bash
dev-tools/$ docker build -t devtools .
```
Choose a template from the following repository and follow the local installation and running instructions : [lenra-io/templates](https://github.com/lenra-io/templates)

