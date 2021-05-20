#!/bin/bash

prometheus_IP=$(kubectl get svc -n gitlab-managed-apps -o jsonpath="{.items[?(@.metadata.name=='prometheus-prometheus-server')].spec.clusterIP}")

login_username=$(kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-username}" | base64 --decode)
login_password=$(kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-password}" | base64 --decode)
login_url="https://monitoring.ingest.${DEPLOYMENT_STAGE}.archive.data.humancellatlas.org"

if [ $DEPLOYMENT_STAGE == "prod" ]
then
    login_url="https://monitoring.ingest.archive.data.humancellatlas.org"
fi

source ../config/environment_$DEPLOYMENT_STAGE
if [[ $* == '--upgrade' ]]
then
    echo "Performing upgrade..."
    helm upgrade ingest-monitoring helm-charts/ingest-monitoring\
        --set prometheusIP=$prometheus_IP\
        --values helm-charts/ingest-monitoring/values.yaml\
        --values helm-charts/ingest-monitoring/environments/$DEPLOYMENT_STAGE.yaml\
        --install
else
    helm upgrade ingest-monitoring helm-charts/ingest-monitoring\
        --set prometheusIP=$prometheus_IP\
        --values helm-charts/ingest-monitoring/values.yaml\
        --values helm-charts/ingest-monitoring/environments/$DEPLOYMENT_STAGE.yaml\
        --force --install
fi



echo "Monitoring deployed!"
echo "===================="
echo "Login at: ${login_url}"
echo "Admin username: ${login_username}"
echo "Admin password: ${login_password}"
