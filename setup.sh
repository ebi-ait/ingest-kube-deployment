#!/usr/bin/env bash

# clone all git repos (via HTTPS)
git clone https://github.com/IGS/ingest-kube-deployment.git
git clone https://github.com/IGS/ingest-core.git
git clone https://github.com/IGS/ingest-broker.git
git clone https://github.com/IGS/ingest-accessioner.git
git clone https://github.com/IGS/ingest-validator.git

# The following 2 repos make use of git submodules that would normally require
# a git clone with a --recursive flag. However, the submodules are defined with
# github URLs that require ssh keys. Here we work around that by obtaining the
# code and cloning it into an "ingestbroker" subdirectory.
git clone https://github.com/IGS/ingest-exporter.git && \
    pushd ingest-exporter && \
    git clone http://github.com/IGS/ingest-broker.git ingestbroker && \
    popd
git clone https://github.com/IGS/ingest-staging-manager.git && \
    pushd ingest-staging-manager && \
    git clone https://github.com/IGS/ingest-broker.git ingestbroker && \
    popd

# build images
cd ingest-core
docker build -t ingest-core:local .
cd ../ingest-broker
docker build -t ingest-demo:local .
cd ../ingest-accessioner
docker build -t ingest-accessioner:local .
cd ../ingest-validator
docker build -t ingest-validator:local .
cd ../ingest-exporter
docker build -t ingest-exporter:local .
cd ../ingest-staging-manager
docker build -t ingest-staging-manager:local .

# Apply Kubernetes configs
cd ../ingest-kube-deployment/local-dev/ingestion
kubectl apply -f service-rabbit-deploy.yml
kubectl apply -f service-mongo-deploy.yml
kubectl apply -f service-ingest-core-deploy.yml
kubectl apply -f service-ingest-demo-deploy.yml
kubectl apply -f rabbit-deploy.yml
kubectl apply -f mongo-deploy.yml
kubectl apply -f ingest-core-deploy.yml
kubectl apply -f ingest-demo-deploy.yml
kubectl apply -f ingest-accessioner-deploy.yml
kubectl apply -f ingest-validator-deploy.yml
kubectl apply -f ingest-exporter-deploy.yml
kubectl apply -f ingest-staging-manager-deploy.yml

# Minikube Dashboard. This invoke's the user's default browser to the dashboard's
# URL.
minikube dashboard

# Check Ingest API
minikube service ingest-core-service --url

# Check Demo UP
minikube service ingest-demo-service --url
