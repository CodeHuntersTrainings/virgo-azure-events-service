#!/bin/sh

kubectl apply -f ./config/namespace.yml

kubectl apply -f ./config/storage-class.yml

kubectl apply -f ./config/deployment.yml

kubectl apply -f ./config/service.yml

kubectl apply -f ./config/ingress.yml
