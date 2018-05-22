#!/usr/bin/env bash
kubectx hca-non-prod
kubens dev-environment
kubectl apply -f ./deployments/
kubectl apply -f ./secrets/
kubectl apply -f ./services/
kubectl apply -f ./stateful_sets/
kubectl get deployments,services,statefulsets