# Vertical Autoscaling
This chart enables vertical autoscaling (scaling of memory and CPU) using [Goldilocks](https://artifacthub.io/packages/helm/fairwinds-stable/goldilocks) and [VPA](https://artifacthub.io/packages/helm/fairwinds-stable/vpa). It's based on the guide [here](https://learnk8s.io/setting-cpu-memory-limits-requests).

## What is it?
VPA provides recommendations for a containers resource limits and requests and Goldilocks provides a nice UI to see these.

## Using it
1. Run `kubectl port-forward svc/vertical-autoscaling-goldilocks-dashboard 8080:80`
1. Go to http://localhost:8080
1. You can see the recommendations provided for each container in the UI
1. You can then update the relevent `deployment.yaml` with the correct settings

## Automatic setting of VPA recommendations
In the dev environment the setting of recommendations is done automatically by Goldilocks. This is due to the `goldilocks.fairwinds.com/vpa-update-mode="auto"` label that is set on the `dev-environment` namespace. This is defined in `infra/Makefile`.

This could be done for staging and prod too after some testing.

## Deployment
1. Go to the `infra` directory
1. `source ../config/environment_<ENV>`
1. `make install-infra-helm-chart-vertical-autoscaling`
