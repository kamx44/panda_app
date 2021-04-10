#!/bin/bash

#---Start Standalone Application on port 8080---
#TO DO
#clone application and compile jar file
#build and run slave
docker build -t standalone-app:ci_env -f ./dockerfiles/standalone_app/Dockerfile .
docker run --name standalone-app -d -p 8083:8080 standalone-app:ci_env
