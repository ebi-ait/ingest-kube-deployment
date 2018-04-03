# Ingest Backup

## Introduction
The backup strategies devised in here is to ensure availability, and prevent significant loss of data after they have been ingested through HCA infrastructure. The utility is meant to complement a more robust way to persist data on Ingest's deployment environment.

While the strategies were created with HCA infrastructure specifically in mind, the tools may be reused to accommodate any system that uses Mongo DB deployed as part of of a cluster of Docker containers.

## Assumptions
Ingest infrastructure is deployed as a system of multiple self contained microservices through Docker with the use of Kubernetes. The backup system is deployed as a Docker container that has direct access to a predefined `mongo-service` Kubernetes service, from which it gets the data it backs up to an S3 bucket defined through the `S3_BUCKET` environment variable.
