# Ingest Ingress

## Helm Install

    helm install -f ingress/values.yaml -f ingess/<env_config>.yaml -n ingress ingress

## Helm Upgrade

	helm upgrade -f ingress/values.yaml -f ingess/<env_config>.yaml ingress ingress

In case an error like the following occurs:

    Error: found in requirements.yaml, but missing in charts/ directory: <nginx-ingress_dir>

do the following

    helm dependency update ingress
