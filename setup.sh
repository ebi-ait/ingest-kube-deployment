#!/usr/bin/env bash
# clone all git repos
git clone git@github.com:HumanCellAtlas/ingest-kube-deployment.git
git clone git@github.com:HumanCellAtlas/ingest-core.git
git clone git@github.com:HumanCellAtlas/ingest-broker.git
git clone git@github.com:HumanCellAtlas/ingest-accessioner.git
git clone git@github.com:HumanCellAtlas/ingest-validator.git
git clone git@github.com:HumanCellAtlas/ingest-exporter.git
git clone git@github.com:HumanCellAtlas/ingest-staging-manager.git
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
# Minikube Dashboard
minikube dashboard
# Check Ingest API
minikube service ingest-core-service --url
# Check Demo UP
minikube service ingest-demo-service --url
