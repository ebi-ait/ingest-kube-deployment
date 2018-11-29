# Ingest Ingress

Ingest reverse proxy mechanism is handled through Kubernetes ingress rules backed by the NGINX ingress controller. Components involved in this system are setup through Helm package manager.

## Setting Up ingress in Deployment

Helm release for the Ingest ingress require environment-specific value files along with the default `value.yaml`. This is due to the fact that services, and their respective ingress rules might change based on the requirements for a specific deployment stage.

When all configuration for the environment is done, setup for the ingress facility for a deployment environment can be invoked through:

    make setup-ingress

in the `apps` directory. This assumes that all local environment variables are all set correctly.

### Configuration

Ingress rules for specific environment can be configured through the respective deployment environment value file. For example, the ingress rules for dev environment are defined in `dev.yaml`. To add a new set of configuration for another environment, a new value file can be created. For general configuration that applies to all environments, the settings can be modified or added in `values.yaml`.

Environment-specific value file follows a DSL-like configuration pattern specified in `templates/ingress.yaml`. At the minimum, an ingress rule entry under `hosts` configuration requires an Ingest service name and the domain it's mapped to.

#### Enforce HTTPS through Redirect

### Route53 Mapping

## Helm Install

    helm install -f ingress/values.yaml -f ingess/<env_config>.yaml -n ingress ingress

## Helm Upgrade

	helm upgrade -f ingress/values.yaml -f ingess/<env_config>.yaml ingress ingress

In case an error like the following occurs:

    Error: found in requirements.yaml, but missing in charts/ directory: <nginx-ingress_dir>

do the following

    helm dependency update ingress
