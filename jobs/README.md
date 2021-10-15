# Jobs
This is a directory for CRON jobs ran inside the cluster

## Creating jobs
1. Copy one of the helm carts in this directory (e.g. `update-project-catalogue`) and rename to match
2. Follow the format of the helm chart and edit as needed
3. Docker container (the one that is deployed to k8s and ran as a CRON job) is located in the `docker-app` subdir
4. Ensure a file called `deploy.sh` is present in the root of the helm chart. This is needed for the `deploy-all.sh` script

## Deploying all jobs
`./deploy-all.sh`