# Check In DCP
This chart runs a cron job that runs a Python script (`./scripts/populate.py`) that periodically checks if the most recent projects in the project catalogue are in the DCP (via azul) and updates the wrangling status to reflect this.

The frequency of the cronjob is defined in `values.yaml` with `schedule`.

## Docker image
The chart uses a docker image defined in `Dockerfile`. This docker image is pushed to the docker repository (quay.io) and used by the chart. It can be updated with the following steps:

1. Make changes to the Dockerfile and/or the scripts that it executes in `docker-assets/`
2. `cd docker-assets`
3. `docker build -t quay.io/ebi-ait/ingest-base-images:ingest-check-in-dcp .`
4. `docker push quay.io/ebi-ait/ingest-base-images:ingest-check-in-dcp`

## Deploying to ingest cluster
1. `source config/environment_<env>` (from ingest-kube-deployment root)
2. `./deploy.sh` (from this folder)