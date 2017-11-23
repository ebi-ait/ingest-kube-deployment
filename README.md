# Ingest Service Deployment

Configuration files for deploying the Ingestion Service on  [Kubernetes](https://kubernetes.io/) clusters.

## Local deployment with Minikube
1. [Install Docker](https://docs.docker.com/engine/installation/)
2. [Install Minikube and prerequisites](https://kubernetes.io/docs/tasks/tools/install-minikube/):
    * [Install Virtual Box](https://www.virtualbox.org/wiki/Downloads)
    * [Install kubecrl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
    * [Install Minikube](https://github.com/kubernetes/minikube/releases)
3. Start the Minikube cluster: `minikube start`
4. Set up a shell to use the Minikube docker-daemon: `eval $(minikube docker-env)`

For the next steps there is a script that can be run: [setup.sh](setup.sh). This should call all the comments needed in order but has no error checking as yet.

5. Clone and build each repository. `cd` into each and run `docker build -t <repository-name>:local .`
    * ingest-core `docker build -t ingest-core:local .`
    * ingest-broker `docker build -t ingest-demo:local .`
    * ingest-accessioner `docker build -t ingest-accessioner:local .`
    * ingest-validator `docker build -t ingest-validator:local .`
    * ingest-exporter `docker build -t ingest-exporter:local .`
    * ingest-staging-manager `docker build -t ingest-staging-manager:local .`    
6. `cd` into ingest-kube-deployment/local-dev/ingestion
7. Apply each of the kubernetes deployment config:
    * First service-<*>-deploy.yml:
        * `kubectl apply -f service-rabbit-deploy.yml`
        * `kubectl apply -f service-mongo-deploy.yml`
        * `kubectl apply -f service-ingest-core-deploy.yml`
        * `kubectl apply -f service-ingest-demo-deploy.yml`
    * Then:
        * `kubectl apply -f rabbit-deploy.yml`
        * `kubectl apply -f mongo-deploy.yml`
    * Then ingest-<*>-deploy.yml:
        * `kubectl apply -f ingest-core-deploy.yml`
        * `kubectl apply -f ingest-demo-deploy.yml`
        * `kubectl apply -f ingest-accessioner-deploy.yml`
        * `kubectl apply -f ingest-validator-deploy.yml`
        * `kubectl apply -f ingest-exporter-deploy.yml`
        * `kubectl apply -f ingest-staging-manager-deploy.yml`
8. Check with Minikube Dashboard `minikube dashboard`
9. Confirm that the Ingestion Service submission API is accessible. Run `minikube service ingest-core-service --url` and browse to the /api endpoint on the returned URL
10. Access the demo service Run `minikube service ingest-demo-service --url` and browse to the URL given

### Modifying a component's source code and redeploying
1. Run `./gradlew assemble` in the root of the source repository
2. Run step 4 as above to ensure that the image is built into the Minikube registry
3. Run `docker build -t <repository-name>:local -f localdevDockerfile .`
4. Delete the current deployment if it is already running `kubectl delete deployment <deployment name>`
5. Redeploy the component on kubernetes: `kubectl apply -f <component deploy yml config>`

## Dev deployment (aws)
1. Set up a kubernetes cluster on AWS using kops: [https://github.com/kubernetes/kops/blob/master/docs/aws.md](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
2. Once the cluster has been set up and verified, `cd` into kube-deployment/dev
3. Apply the namespace configuration for the dev environment. `kubectl apply -f ingestion/dev-namespace.yml`
4. `cd` into the secrets folder. Open `api-key-secrets.yml` in a text editor. Replace the placeholders with the relevant secret, base64 encoded: `echo -n mysecretpasssword | base64` .(NOTE: even if the secret is itself a base64 encoded string, it still needs to be base64 encoded again since kubernetes will attempt to base64 decode any secrets defined in this file). Apply the secret to the cluster with `kubectl apply -f api-key-secrets.yml`
5. `cd` into kube-deployment/dev/ingestion.
6. Apply each `service-....yml` file. `kubectl apply -f service-....yml`
7. Apply the mongo and rabbit deployment configs. `kubectl apply -f mongo-deploy.yml`  `kubectl apply -f rabbit-deploy.yml`
8. Apply each of the other ingest-...yml deployment configs. `kubectl apply -f ingest-...yml`

## Staging deployment (aws)
Similar to dev deployment. If a cluster has already been created using kops it can be reused for these steps.

1. If not already setup, set up a kubernetes cluster on AWS using kops: [https://github.com/kubernetes/kops/blob/master/docs/aws.md](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
2. Once the cluster has been set up and verified, `cd` into kube-deployment/staging
3. Apply the namespace configuration for the staging environment. `kubectl apply -f ingestion/staging-namespace.yml`
4. `cd` into the secrets folder. Open `api-key-secrets.yml` in a text editor. Replace the placeholders with the relevant secret, base64 encoded: `echo -n mysecretpasssword | base64` (NOTE: even if the secret is itself a base64 encoded string, it still needs to be base64 encoded again since kubernetes will attempt to base64 decode any secrets defined in this file). Apply the secret to the cluster with `kubectl apply -f api-key-secrets.yml`
5. `cd` into kube-deployment/staging/ingestion.
6. Apply each `service-....yml` file. `kubectl apply -f service-....yml`
7. Apply the mongo and rabbit deployment configs. `kubectl apply -f mongo-deploy.yml`  `kubectl apply -f rabbit-deploy.yml`
8. Apply each of the other ingest-...yml deployment configs. `kubectl apply -f ingest-...yml`
