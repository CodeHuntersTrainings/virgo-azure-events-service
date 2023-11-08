#!/bin/sh

# az login is necessary before running this script
AcrLink="codehunterstrainingacr.azurecr.io"
LocalImageName="events-service"
TargetTag="czirjak"

./mvnw clean install -DskipTests=true

docker build --tag "$LocalImageName:latest" .

az acr login -n codehunterstrainingacr

docker tag "$LocalImageName:latest" "${AcrLink}/${LocalImageName}:${TargetTag}"

docker push "${AcrLink}/${LocalImageName}:${TargetTag}"
