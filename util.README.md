# Deployment Utility

The deployment utility (`util`) is small set of scripts that aims to simplify the process of deploying Ingest components to our Kubernetes cluster. Operations within this utility are programmed to primarily locate the relevant configuration files for each deployment environment.

## Background

Ingest has 3 deployment environments: development, staging, and production. Any change to the system is expected to go through each environment in that given order.

## Release

The first stage of deployment is the development release. This can be handled through the `release` operation of the `util` script. All it does is update the given component in the dev config (`config/environment_dev`).

    ./util release <ingest_component> <image_version>

For example, to release version `90bcbda` of Ingest Core, the following can be executed:

    ./util release core 90bcbda

## Promotion

After the initial development release, changes can then be promoted to subsequent stages through the `promote` function. This follows the strict order of deployment and so only development releases can be promoted to staging, and only staging releases can be promoted to production.

    ./util promote <target_env> <ingest_component>
