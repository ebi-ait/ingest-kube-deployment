# update-project-catalogue
This chart runs a cron job that runs a Python script (`./scripts/populate.py`) that periodically checks if the most recent projects in the project catalogue are in the DCP (via azul) and updates the wrangling status to reflect this. It also checks crossref and updates `publicationsInfo` to reflect the most up to date info from crossref.

The frequency of the cronjob is defined in `values.yaml` with `schedule`.

## Docker image
The chart uses a docker image defined in `Dockerfile`. This docker image is pushed to the docker repository (quay.io) and used by the chart. It can be updated with the following steps:

1. Make changes to the Dockerfile and/or the scripts that it executes in `docker-app/`
2. Update the version in `docker-app/version.sh`
3. Commit and push the changes
4. `cd docker-app && ./release.sh`

## Deploying to ingest cluster
1. `source config/environment_<env>` (from ingest-kube-deployment root)
2. `./deploy.sh` (from this folder)

## Running standalone if you want to update the catalogue now and with more than 50 projects
If you want to update the catalogue now and not wait for the cron you can spin up a transient container of the image with `kubectl run`. This is useful if you want to update more than the default of 50 projects that the cron job does.

1. `source config/environment_<env>` (from ingest-kube-deployment root)
2. `source docker-app/version.sh` (from this repo)
2. `PROJECT_COUNT=<desired number of projects to query>`
3. `kubectl run update-catalogue --image=$DOCKER_REPO:$DOCKER_TAG --env="COUNT=$PROJECT_COUNT" -it --rm`