# kube-deployment

config files for deploying the Ingestion Service on kubernetes clusters

## Local deployment with Minikube
1. Install Docker
2. Install Minikube and prerequisites: [https://kubernetes.io/docs/tasks/tools/install-minikube/](https://kubernetes.io/docs/tasks/tools/install-minikube/)
3. Start the Minikube cluster: `minikube start`
4. Set up a shell to use the Minikube docker-daemon: `eval $(minikube docker-env)`
5. Clone and build each repository. `cd` into each and run `docker build -t <repository-name>:latest .`
6. `cd` into kube-deployment/local-dev
6. Apply each of the kubernetes deployment configs in submission-service and validation-service. Be sure to do the service-...-deploy.yml configs in kube-deployment/submission-service first: `kubectl apply -f <yml config>`
7. Confirm that the Ingestion Service submission API is accessible. Run `minikube service ingest-service-api --url` and browse to the /api endpoint on the returned URL

### Modifying a component's source code and redeploying
1. Run `./gradlew assemble in the root of the source repository`
2. Run step 4 as above to ensure that the image is built into the Minikube registry
3. Run `docker build -t <repository-name>:latest -f localdevDockerfile .`
4. Redeploy the component on kubernetes: `kubectl apply -f <component deploy yml config>`

## Dev deployment (aws)
1. Set up a kubernetes cluster on AWS using kops: [https://github.com/kubernetes/kops/blob/master/docs/aws.md](https://github.com/kubernetes/kops/blob/master/docs/aws.md)
2. Once the cluster has been set up and verified, `cd` into kube-deployment/dev
3. Perform step 6 as above
