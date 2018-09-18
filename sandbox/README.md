# Sandbox Deployment Notes

## Switching Modes

The sandbox environment (also known as "testing") can be switched between fully isolated configuration to one that integrates with a working upload service. By default, the deployment templates are set to point to other (external) components based on the present working Kubernetes cluster. The configuration can be switched through patching.

### Using the Mock Upload Service

The mock upload service is deployed as a Kubernetes resource along with all the proper Ingest components. To switch to using this mock service, the Staging Manager and the Validator need to be patched to point to it. This can be done using `patch-staging-manager.yml` and `patch-validator.yml`. For example:

    kubectl patch deployment ingest-validator -n testing-environment -p "$(cat patch-validator.yml)"
	

### Switching Back to Integrated Configuration

From a patched configuration that uses the mock upload service, the sandbox environment can be swtiched back to integrated mode with a live upload service by rerunning the deployment script (`make deploy-app-*`).

Note that in this mode, the current version of the scale testing script may not run correctly.
