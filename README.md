# Ingest Service Deployment

Deployment setup for the Ingestion Service on  [Kubernetes](https://kubernetes.io/) clusters.

## Repository structure
- `/apps`
	-  ingest "applications" - deployments that provide functionality to our end users
- `/infra`
	- deployments, roles, service accounts, stateful sets etc. that support ingest "applications". These include things like mongo, monitoring, neo4j etc.
	- terraform configuration for provisioning an ingest cluster
- `/jobs`
	-  one off jobs that can be ran
- `/cron-jobs`
	- regular jobs that are scheduled
- `/config`
	- Global configuration files used to deploy to each environment

## About the cluster configuration
- Our cluster is deployed to Amazon EKS
- Each cluster is named `ingest-eks-<ENV>` e.g. `ingest-eks-dev`
- The type of node and number of nodes is configured in `config/environment_<ENV>`  via `TF_VAR_node_size` and `TF_VAR_node_count`
- Everything is deployed under one namespace of the form `<ENV>-environment` (e.g. `dev-environment`)

## Development setup
### Local environment
We have migrated to helm 3, make sure to install the correct package version (>=3) on your system.
#### Mac
1. `git clone <this-repo-url>`
2. Install [terraform](https://www.terraform.io/intro/getting-started/install.html) 0.12.25:
    - `brew install warrensbox/tap/tfswitch`
    - `tfswitch 0.12.25`
3. [Ensure your pip is running on python 3](https://opensource.com/article/19/5/python-3-default-mac).
3. Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html): `pip install awscli`.
4. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/configure-kubectl.html): `brew install aws-iam-authenticator`
5. Install kubectl: `brew install kubernetes-cli`
6. Install kubectx (kubens included): `brew install kubectx`
7. Install [helm](https://github.com/kubernetes/helm): `brew install kubernetes-helm`
8. `mkdir ~/.kube`
9. Install [jq](https://stedolan.github.io/jq/) `brew install jq`

#### Ubuntu
1. `git clone <this-repo-url>`
2. Install terraform via [tfswitch](https://tfswitch.warrensbox.com/Install/)
	- `tfswitch 0.12.25`
3. Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html): `pip install awscli`.
4. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
5. Install kubectl: `sudo snap install kubectl --classic`
6. Install [kubectx and kubens](https://github.com/ahmetb/kubectx).
7. Install helm: `sudo snap install helm --classic`
8. `mkdir ~/.kube`
9. Install [jq](https://stedolan.github.io/jq), if required. `sudo apt-get install jq`

### Configuring AWS connection
1. `aws configure --profile embl-ebi`
	- See [Quickly Configure ASW CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) for `AWS Access Key ID` & `AWS Secret Access Key`
	- Set region to `us-east-1`
2. Edit your `./aws/config` to look like this:
```
[profile embl-ebi]
role_arn = arn:aws:iam::871979166454:role/ingest-devops
source_profile = ebi
region = us-east-1
```
### Access existing cluster
These steps assumes you have the correct aws credentials and local environment tools set up correctly. This only has to be run one time.

1. `source config/environment_<ENV>` (e.g. `source config/environment_dev`)
2. `cd infra`
3. `make retrieve-kubeconfig-<ENV>` 
4. `kubectx`
	- Should now show `ingest-eks-<ENV>`

### Create new cluster
These steps assumes you have the correct aws credentials and local environment tools set up correctly.

**NOTE**: You may want to skip some of these steps if the same cluster has been created previously and not completely destroyed


1. `ENV=<YOUR NEW ENVIRONMENT NAME`> (e.g. `ENV=testing`)
1. `cp config/environment_template config/environment_$ENV`
1. `cp config/replicas/environment_template config/replicas/environment_$ENV`
1. Replace all values in  `config/environment_$ENV` marked as 'PROVIDE...' with the appropriate value
1. Ensure the VPC IP in this config file is a valid and unique VPC IP value.
	- You can check existing VPC IPs in the IPv4 CIDR section of the [VPC dashboard](https://us-east-1.console.aws.amazon.com/vpc/home?region=us-east-1#vpcs:)
1. `source config/environment_$ENV`
1. Duplicate mongo s3 access secrets from dev (this is used to restore the mongodb)
	```bash
	aws secretsmanager get-secret-value \
		--secret-id ingest/dev/mongo-backup/s3-access \
		--query SecretString \
		--output text > $ENV_secrets.json  && \
	aws secretsmanager create-secret \
			--name ingest/$ENV/mongo-backup/s3-access \
			--secret-string file://$ENV_secrets.json && \
	rm $ENV_secrets.json
	```
1. Duplicate webhook url alerts (you may want to change this value afterwards)
	```bash
	aws secretsmanager get-secret-value \
		--secret-id ingest/dev/alerts \
		--query SecretString \
		--output text > $ENV_secrets.json  && \
	aws secretsmanager create-secret \
			--name ingest/$ENV/alerts \
			--secret-string file://$ENV_secrets.json && \
	rm $ENV_secrets.json
	```
1. Duplicate the secrets from `ingest/dev/secrets`. You may want to change the values of these secrets later on
	```bash
	aws secretsmanager get-secret-value \
		 --secret-id ingest/dev/secrets \
		 --query SecretString \
		 --output text > $ENV_secrets.json  && \
	aws secretsmanager create-secret \
		--name ingest/$ENV/secrets \
		--secret-string file://$ENV_secrets.json && \
	rm $ENV_secrets.json
	```
1. `cd infra`
1. `cp helm-charts/ingress/environments/dev.yaml helm-charts/ingress/environments/$ENV.yaml`
1. Edit `helm-charts/ingress/environments/$ENV.yaml` to have values corresponding to `$ENV`
1. `make create-cluster-$ENV`
	- Ensure the terraform changes are correct before applying
1. Configure new DNS records:
	1. Navigate to [Route53](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones#)
	1. Copy the result of `kubectl get svc ingress-ingress-nginx-controller -o=jsonpath="{.status.loadBalancer.ingress[0].hostname}"` to your clipboard
	1. Configure new DNS records to match those you created in `helm-charts/ingress/environments/$ENV.yaml` pointing to the address you copied above
1. Create a new certificate for your new domains from the [AWS certificate manager](https://us-east-1.console.aws.amazon.com/acm/home?region=us-east-1#/certificates/list) and replace the value for the ARN in `helm-charts/ingress/environments/$ENV.yaml` with your new ARN
1. `make setup-ingress-$ENV`
1. `cd ../apps`
1. `make deploy-secrets`
1. `cd ../infra`
1. `make install-infra-helm-chart-ingest-monitoring`
1. `cd ../apps`
1. `cp dev.yaml $ENV.yaml`
1. Edit `$ENV.yaml` to correspond to your new environment
1. `make deploy-all`
	- This will deploy all images specified in `apps/Makefile`, you may want to deploy different images

### Modify and deploy updated EKS and AWS infrastructure
These steps assumes you have the correct aws credentials + local environment tools set up correctly and that you have followed the instructions to access the existing cluster.

1. `source config/environment_<ENV>`
1. Update infra/eks.tf as desired
1. `cd infra`
1. `make modify-cluster-<ENV>` 

### Destroy ingest eks cluster (aws)
These steps assumes you have the correct aws credentials + local environment tools set up correctly and that you have followed the instructions to access the existing cluster.

These steps will bring down the entire infrastructure and all the resources for your ingest kubernetes cluster and environment. This goes all the way up to the VPC that was created for this environment's cluster.

1. `ENV=<ENVIRONMENT NAME TO REMOVE`> (e.g. `ENV=testing`)
1. `source config/environment_$ENV`
1. `cd infra`
1. `make destroy-cluster-$ENV`
	*Note*: The system could encounter an error (most likely a timeout) during the destroy operation. Failing to remove some resources such as the VPC, network interfaces, etc. can be tolerated if the ultimate goal is to rebuild the cluster. In the case VPC, for example, the EKS cluster will just reuse it once recreated.
1. `aws secretsmanager delete-secret --secret-id `ingest/$ENV/secrets`

### Reusing Undeleted Network Components

The Terraform manifest declares some network components like the VPC and subnets, that for some reason refuse to get delete during the destroy operation. This operation needs some work to improve, but at the meantime, a workaround is suggested below.

*Force the subnet declarations to use the existent ones* by overriding the `cidr_block` attribute of the `aws_subnet.ingest_eks` resource. To see the undeleted subnet components, use `terraform show`.

For example, in dev, the CIDR is set to `10.40.0.0/16`. The Terraform manifest at the time of writing makes computations with this on build time that often results in 2 subnets `10.40.0.0/24` and `10.40.1.0/24` that could refuse deletion. To make the Terraform build reuse these components, the `cidr_block` attribute under the `aws_subnet` resource can be set to the following:

    cidr_block        = "10.40.${count.index}.0/24"

### Install all backend services (mongo, redis, rabbit, ingest-monitoring, etc)
1. `cd infra`
2. `make deploy-backend-services-<ENV>`

### Ingest Monitoring
#### Install
1. `source config/environment_<ENV>`
2. `cd infra`
3. `make install-infra-helm-chart-ingest-monitoring`
4. `kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-password}" | base64 --decode`
  - Copy the result to your clipboard
5. Navigate to `https://monitoring.ingest.<ENV>.archive.data.humancellatlas.org`
  - Login with `admin` and the result from step 4

#### Upgrade
If you would like to change the dashboard for Ingest Monitoring, you must save the JSON file in this repo and deploy it.

1. Make the changes to the dashboard in any environment
2. Copy the dashboard's JSON model to the clipboard
  - dashboard settings (cog at top) -> JSON model
3. Replace the contents of `infra/helm-charts/ingest-monitoring/dashboards/ingest-monitoring.json` with the contents of your clipboard
4. `source config/environment_<ENV>`
4. `cd infra && make upgrade upgrade-infra-helm-chart-ingest-monitoring` 
  - The script will replace any references to e.g. prod-environment with the environment you are deploying to. 

### GitLab Runner
GitLab runners can be deployed to run ingest CI/CD jobs. At the time of writing they are only deployed to the `ingest-eks-dev` cluster.

#### Deploy (optional)
1. Ensure the `gitlab_group_runner_token` exists in `ingest/<ENV>/secrets`
	1. If not, you can get the value from the "Set up a group runner manually" section in [GitLab's CI/CD section](https://gitlab.ebi.ac.uk/groups/hca/-/settings/ci_cd)
1. `source config/environment_<ENV>`
1. `make install-infra-helm-chart-gitlab-runner`

### Vertical autoscaling
Vertical autoscaling can be deployed to give recommendations on CPU and memory constraints for containers. See `infra/vertical-autoscaling/README.md`.

### Deploy CRON jobs
CRON jobs are located in `cron-jobs/`. Further details for deploying and updating CRON jobs are located in `cron-jobs/README.md` and details on individual CRON jobs are found in their helm chart's READMEs.

They can be deployed all at once by running:

1. `source config/environment_ENVNAME`
2. `cd cron-jobs`
3. `./deploy-all.sh`

### Deploy and Upgrade Ingest Applications
Deployments are automatically handled by [Gitlab](https://gitlab.ebi.ac.uk/) but you can still manually deploy if required (see below). However, `ontology` is not deployed by Gitlab but there is a special command for deploying ontology (see below).

### Manually deploy one ingest application
1 `source config/environment_<ENV>`
1. `cd apps`
1. `make deploy-app-APPNAME image=IMAGE_NAME` E.g. `make deploy-app-ingest-core image=quay.io/ebi-ait/ingest-core:1c1f6ab9`

### Deploy ontology
1. Change the branch or tag in `config/environment_<ENV>`
1. `cd apps`
1. `make deploy-ontology`

### Deploy cloudwatch log exporter
1. Make sure you have followed the instructions above to create or access an existing eks cluster
2. Source the configuration file for the environment
3. Make sure the secrets api-keys and aws-keys are deployed substituted with valid base64 encoded values
4. `cd infra` and `make install-infra-helm-chart-fluentd-cloudwatch`

### Accessing RabbitMQ Management UI
tldr: Use this command: `kubectl port-forward rabbit-0 15672:15672`

`kubectl port-forward <localhost-port>:15672`
https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/

1. Get the rabbit service local port
`kubectl get service rabbit-service`
2. Get the rabbit service pod
`kubectl get pods | grep rabbit`
3. Access the RabbitMQ Management UI
`kubectl port-forward rabbit-0 15672:15672`

### Mongo help
#### SSH into the container

```bash
kubectl exec -it mongo-0 -- sh
```

#### Using a MongoDB Client

1. setup port forwarding
```bash
kubectl port-forward mongo-0 27017:27017
```

2. connect to `mongodb://localhost:27017/admin`

#### Restoring Mongo DB backup

1. Download the latest compressed directory of backup from s3 bucket `ingest-db-backup`
2. Copy the backup to the mongo pod.
```
$ kubectl cp 2020-05-21T00_00.tar.gz staging-environment/mongo-0:/2020-05-21T00_00.tar.gz
```

3. SSH into the mongo pod. Verify the file is copied there.
```
$ kubectl exec -it mongo-0 -- sh
```

4. Extract dump files
```
$ tar -xzvf 2020-05-21T00_00.tar.gz
```
This will create a directory structure, `data/db/dump/2020-05-21T00_00`, which contains the output of the `mongodump`

5. Go to the backup dir and restore.

```
$ cd data/db/dump/
$ mongorestore 2020-05-21T00_00 --drop
```

For more info on the restoring data, please refer to https://github.com/ebi-ait/ingest-kube-deployment/tree/master/infra/helm-charts/mongo/charts/ingestbackup#restoring-data

6. Remove the dump files
```
$ rm -rf 2020-05-21T00_00
```
