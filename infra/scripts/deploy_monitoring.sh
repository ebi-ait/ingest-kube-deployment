#!/bin/bash

loki_IP=$(kubectl get svc -o jsonpath="{.items[?(@.metadata.name=='ingest-monitoring-loki')].spec.clusterIP}")
prometheus_IP=$(kubectl get svc -n gitlab-managed-apps -o jsonpath="{.items[?(@.metadata.name=='prometheus-prometheus-server')].spec.clusterIP}")

source ../config/environment_$DEPLOYMENT_STAGE &&\
helm upgrade ingest-monitoring ./helm-charts/ingest-monitoring\
    --set lokiIP=$loki_IP\
    --set prometheusIP=$prometheus_IP\
    --force --install