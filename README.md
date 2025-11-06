# brown-jec

Repo to build JEC image for Brown use

## Description

This repo contains a working Dockerfile needed to build the Atlassian provided
[JEC code](https://github.com/atlassian/jec) available from GitHub. 

## Support scripting

Script support is de pendant on having a built image for that script. Currently
there are the available scripts supported:

* python 3.14
* uv (python 3.14)

## Images

Images are available from harbor at:

* harbor.services.brown.edu/library/jec-uv
* harbor.services.brown.edu/library/jec-python

Use the images location in your `deployment.yaml` file.