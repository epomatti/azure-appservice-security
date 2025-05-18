#!/bin/bash

repository=app
local_image="app-local"
acr_image="$acr.azurecr.io/$repository:latest"

az acr login --name $acr
docker build -t $local_image .
docker tag $local_image $acr_image
docker push $acr_image
