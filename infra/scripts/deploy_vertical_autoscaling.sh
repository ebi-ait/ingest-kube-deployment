#!/bin/bash

prometheus_IP=$(kubectl get svc -n gitlab-managed-apps -o jsonpath="{.items[?(@.metadata.name=='prometheus-prometheus-server')].spec.clusterIP}")

cd helm-charts
helm dependency update vertical-autoscaling && helm package vertical-autoscaling

if [[ $* == '--upgrade' ]]
then
    helm upgrade --values vertical-autoscaling/values.yaml --set vpa.recommender.extraArgs.prometheus-address=$prometheus_IP vertical-autoscaling ./vertical-autoscaling --install
else
    helm upgrade --values vertical-autoscaling/values.yaml --set vpa.recommender.extraArgs.prometheus-address=$prometheus_IP vertical-autoscaling ./vertical-autoscaling --install --force
fi

rm *.tgz

kubectl label ns $DEPLOYMENT_STAGE-environment goldilocks.fairwinds.com/enabled=true --overwrite


if [ $DEPLOYMENT_STAGE == "dev" ]
then
    echo "Turning on auto VPA update";
    kubectl label ns $DEPLOYMENT_STAGE-environment goldilocks.fairwinds.com/vpa-update-mode="auto" --overwrite
fi