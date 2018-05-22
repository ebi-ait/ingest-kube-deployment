#!/usr/bin/env bash
# Deployment configs
kubectl apply -f $environment/deployments/ingest-accessioner-deploy.yml
kubectl apply -f $environment/deployments/ingest-archiver-deploy.yml
kubectl apply -f $environment/deployments/ingest-core-deploy.yml
kubectl apply -f $environment/deployments/ingest-demo-deploy.yml
kubectl apply -f $environment/deployments/ingest-exporter-deploy.yml
kubectl apply -f $environment/deployments/ingest-ontology-deploy.yml
kubectl apply -f $environment/deployments/ingest-staging-manager-deploy.yml
kubectl apply -f $environment/deployments/ingest-state-tracking-deploy.yml
kubectl apply -f $environment/deployments/ingest-validator-deploy.yml
kubectl apply -f $environment/deployments/rabbit-deploy.yml

# stateful set configs
kubectl apply -f $environment/stateful_sets/mongo-stateful-deploy.yml
kubectl apply -f $environment/stateful_sets/redis-stateful-deploy.yml

# service configs
kubectl apply -f $environment/services/ingest-core-service.yml
kubectl apply -f $environment/services/ingest-demo-service.yml
kubectl apply -f $environment/services/ingest-ontology-service.yml
kubectl apply -f $environment/services/mongo-service.yml
kubectl apply -f $environment/services/rabbit-service.yml
