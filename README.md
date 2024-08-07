# Ingest Service Deployment

Deployment setup for the Ingestion Service on  [Kubernetes](https://kubernetes.io/) clusters.

## Set up local environment
We have migrated to helm 3, make sure to install the correct package version (>=3) on your system.
### Mac
1. `git clone <this-repo-url>`
2. [Ensure your pip is running on python 3](https://opensource.com/article/19/5/python-3-default-mac).
3. install needed software
```bash
brew install warrensbox/tap/tfswitch
tfswitch 0.13.5
pip install awscli
brew install aws-iam-authenticator
brew install kubernetes-cli
brew install kubectx
brew install kubernetes-helm
mkdir ~/.kube
brew install jq
```

### Ubuntu
1. `git clone <this-repo-url>`
2. Install terraform with the [terraform instructions](https://learn.hashicorp.com/terraform/getting-started/install.html).
  - If you install with `sudo snap install terraform` you may run into the error `Error configuring the backend "s3": NoCredentialProviders: no valid providers in chain. Deprecated.`
3. Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html): `pip install awscli`.
4. Install [aws-iam-authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
5. Install kubectl 1.22: `sudo snap install kubectl@1.22 --classic`
6. Install [kubectx and kubens](https://github.com/ahmetb/kubectx).
7. Install helm: `sudo snap install helm --classic`
8. `mkdir ~/.kube`
9. Install [jq](https://stedolan.github.io/jq), if required. `sudo apt-get install jq`

## Configuring AWS connection
1. `aws configure --profile embl-ebi`
	- See [Quickly Configure ASW CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html#cli-quick-configuration) for `AWS Access Key ID` & `AWS Secret Access Key`
	- Set region to `us-east-1`
2. Edit your `./aws/config` to look like this:
```
[profile ebi]

[profile embl-ebi]
role_arn = arn:aws:iam::871979166454:role/ingest-devops
source_profile = ebi
region = us-east-1
```


## Access/Create/Modify/Destroy EKS Clusters

### Access existing ingest eks cluster (aws)
These steps assumes you have the correct aws credentials and local environment tools set up correctly. This only has to be run one time.
1. `source config/environment_ENVNAME` where ENVNAME is the name of the environment you are trying to access
2. `cd infra`
3. `make retrieve-kubeconfig-ENVNAME` where ENVNAME is the name of the environment you are trying to access
4. `kubectl`, `kubens`, `kubectx`, and `helm` will now be tied to the cluster you have sourced in the step above.

### How to access dashboard
These steps assumes you have the correct aws credentials + local environment tools set up correctly and that you have followed the instructions to access the existing cluster.
1. `kubectx ingest-eks-ENVNAME` where ENVNAME is the name of the cluster environment you are trying to access
2. Generate token (it will be copied to the clipboard):
	`kubectl -n kube-system describe secrets/$(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}') | grep token: | cut -d: -f2 | xargs | pbcopy`
3. Start the proxy:
	`kubectl proxy`
4. Browse to the [dashboard endpoint](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/overview?namespace=default)
5. Choose Token and paste token from step 2 above

### Create new ingest eks cluster (aws)
These steps assumes you have the correct aws credentials and local environment tools set up correctly.
These steps will set up a new ingest environment from scratch via terraform and will also apply all kubernetes monitoring and dashboard configs, RBAC role and aws auth setup.
1. `cp config/environment_template config/environment_ENVNAME` where envname should reflect the name of the environment you are trying to create.
2. Replace all values marked as 'PROVIDE...' with the appropriate value
3. Ensure the aws profile name in this config is mapped to the name of the aws profile in your ~/.aws/config or ~/.aws/credentials/ path that has admin access to the relevant aws account.
4. Ensure the VPC IP in this config file is a valid and unique VPC IP value.
5. `source config/environment_ENVNAME` where ENVNAME reflects the name of the environment in the config file you created above
6. `cd infra`
7. `make create-cluster-ENVNAME` where ENVNAME is the name of the environment you are trying to create. This step will also deploy the backend services (mongo, redis, rabbit)
8. Follow the steps to access the kubernetes dashboard. Note that there is no server-side component (tiller) in helm 3.
9. Follow instructions below to deploy applications.

### Modify and deploy updated EKS and AWS infrastructure
These steps assumes you have the correct aws credentials + local environment tools set up correctly and that you have followed the instructions to access the existing cluster.
1. `source config/environment_ENVNAME` where ENVNAME reflects the name of the environment you are trying to modify.
2. Update infra/eks.tf as desired.
2. `cd infra`
3. `make modify-cluster-ENVNAME` where ENVNAME reflects the name of the environment you are trying to modify.

### Destroy ingest eks cluster (aws)
These steps assumes you have the correct aws credentials + local environment tools set up correctly and that you have followed the instructions to access the existing cluster.
These steps will bring down the entire infrastructure and all the resources for your ingest kubernetes cluster and environment. This goes all the way up to the VPC that was created for this environment's cluster.
1. Follow setups 2-5 in 'Create new ingest eks cluster (aws)' if config/environment_ENVNAME does not exist where ENVNAME is the environment you are trying to destroy
2. `source config/environment_ENVNAME` where ENVNAME reflects the name of the environment in the config file you created above
3. `cd infra`
4. `make destroy-cluster-ENVNAME` where ENVNAME is the name of the environment you are trying to destroy
*Note*: The system could encounter an error (most likely a timeout) during the destroy operation. Failing to remove some resources such as the VPC, network interfaces, etc. can be tolerated if the ultimate goal is to rebuild the cluster. In the case VPC, for example, the EKS cluster will just reuse it once recreated.

#### Reusing Undeleted Network Components

The Terraform manifest declares some network components like the VPC and subnets, that for some reason refuse to get delete during the destroy operation. This operation needs some work to improve, but at the meantime, a workaround is suggested below.

*Force the subnet declarations to use the existent ones* by overriding the `cidr_block` attribute of the `aws_subnet.ingest_eks` resource. To see the undeleted subnet components, use `terraform show`.

For example, in dev, the CIDR is set to `10.40.0.0/16`. The Terraform manifest at the time of writing makes computations with this on build time that often results in 2 subnets `10.40.0.0/24` and `10.40.1.0/24` that could refuse deletion. To make the Terraform build reuse these components, the `cidr_block` attribute under the `aws_subnet` resource can be set to the following:

    cidr_block        = "10.40.${count.index}.0/24"


## Install and Upgrade Core Ingest Backend Services (mongo, redis, rabbit)

### Install backend services (mongo, redis, rabbit)
1. `cd infra`
2. `make deploy-backend-services-ENVNAME` where ENVNAME is the name of the environment you are trying to create.

### Upgrade backend services (mongo, redis, rabbit)
Coming soon

## Install Ingest Monitoring Dashboard (Grafana, Prometheus)
1. `source config/environment_ENVNAME`
2. `cd infra`
3. `make install-infra-helm-chart-ingest-monitoring`
4. `kubectl get secret aws-keys -o jsonpath="{.data.grafana-admin-password}" | base64 --decode`
  - Copy the result to your clipboard
5. Navigate to `https://monitoring.ingest.ENVNAME.archive.data.humancellatlas.org`
  - Login with `admin` and the result from step 4

### Upgrading Ingest Monitoring Dashboard
If you would like to change the dashboard for Ingest Monitoring, you must save the JSON file in this repo and deploy it.

1. Make the changes to the dashboard in any environment
2. Copy the dashboard's JSON model to the clipboard
  - dashboard settings (cog at top) -> JSON model
3. Replace the contents of `infra/helm-charts/ingest-monitoring/dashboards/ingest-monitoring.json` with the contents of your clipboard
4. `source config/environment_ENVNAME`
4. `cd infra && make upgrade upgrade-infra-helm-chart-ingest-monitoring` 
  - The script will replace any references to e.g. prod-environment with the environment you are deploying to. 

### Vertical autoscaling
Vertical autoscaling can be deployed to give recommendations on CPU and memory constraints for containers. See `infra/vertical-autoscaling/README.md`.

## Deploy CRON jobs
CRON jobs are located in `cron-jobs/`. Further details for deploying and updating CRON jobs are located in `cron-jobs/README.md` and details on individual CRON jobs are found in their helm chart's READMEs.

They can be deployed all at once by running:

1. `source config/environment_ENVNAME`
2. `cd cron-jobs`
3. `./deploy-all.sh`

## Deploy and Upgrade Ingest Applications
Deployments are automatically handled by [Gitlab](https://gitlab.ebi.ac.uk/) but you can still manually deploy if required (see below). However, `ontology` is not deployed by Gitlab but there is a special command for deploying ontology (see below).

### Manually deploy one kubernetes dockerized applications to an environment (aws)
1. Make sure you have followed the instructions above to create or access an existing eks cluster
2. `source config/environment_ENVNAME`
3. `cd apps`
4. `make deploy-app-APPNAME image=IMAGE_NAME` where APPNAME is the name of the ingest application. and IMAGE_NAME is the image you want to deploy For example, `make deploy-app-ingest-core image=quay.io/ebi-ait/ingest-core:1c1f6ab9`

### Deploy ontology
See [docs](https://github.com/ebi-ait/hca-ebi-dev-team/blob/master/docs/operations_tasks/HCAO-release.md)

**Notes on Fresh Installation**

Before running the script to redeploy all ingest components, make sure that secrets have been properly defined in the AWS security manager. At the time of writing, the following secrets are required to be defined in `dcp/ingest/<deployment_env>/secrets` to ensure that deployments go smoothly:

* `emails`
* `staging_api_key` (retrieve this from `dcp/upload/staging/secrets`)
* `exporter_auth_info`
*  `ingest-monitoring`
---

1. Make sure you have followed the instructions above to create or access an existing eks cluster
2. Change the branch or tag in `config/environment_ENVNAME` if needed where ENVNAME is the environment you are deploying to.
3. `cd apps`
4. `make deploy-all-apps` where APPNAME is the name of the ingest application.

### After Deployment

All requests to the Ingest cluster go through the Ingress controller. Any outward facing service needs to be mapped to the Ingress service for it to work correctly. This is set through the AWS Route 53 mapping.

1. The first step is to retrieve the external IP of the Ingress service load balancer. This can be done using `kubectl get services -l app=ingress-nginx`.
2. Copy the external IP and go the Route 53 service dashboard on the AWS Web console.
3. From the Hosted Zones, search for `<deployment_env>.data.humancellatlas.org` and search for Ingest related records.
4. Update each record to use the Ingress load balancer external IP as alias.
5. To ensure that each record are set correctly, run a quick test using the Test Record Set facility on the AWS Web console.

## Deploy cloudwatch log exporter
1. Make sure you have followed the instructions above to create or access an existing eks cluster
2. Source the configuration file for the environment
3. Make sure the secrets api-keys and aws-keys are deployed substituted with valid base64 encoded values
4. `cd infra` and `make install-infra-helm-chart-fluentd-cloudwatch`

## CI/CD Setup

### Promote one application environment configurations to another (ie dev => integration)
Coming soon

## Local Setup

### Local deployment with Minikube
Coming soon

## Accessing RabbitMQ Management UI
tldr: Use this command: `kubectl port-forward rabbit-0 15672:15672`

`kubectl port-forward <localhost-port>:15672`
https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/

1. Get the rabbit service local port
`kubectl get service rabbit-service`
2. Get the rabbit service pod
`kubectl get pods | grep rabbit`
3. Access the RabbitMQ Management UI
`kubectl port-forward rabbit-0 15672:15672`

## Accessing Mongo DB container
### SSH into the container

```bash
kubectl exec -it mongo-0 -- sh
```

### Using a MongoDB Client

1. setup port forwarding
```bash
kubectl port-forward mongo-0 27017:27017
```

2. connect to `mongodb://localhost:27017/admin`

### Restoring Mongo DB backup

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

## Accessing our PostgreSQL DB instance on AWS

### Installing a PostgreSQL client to your local computer
You can use the open-source tool pgAdmin to connect to your RDS for PostgreSQL DB instance.
You can download and install pgAdmin from http://www.pgadmin.org/.

### Get the connection details for our PostgreSQL DB instance from AWS Secrets Manager

1. Sign in to the [AWS Management Console](https://embl-ebi.awsapps.com/start#/) and open the AWS Secrets Manager
2. In the filter type `database` and select the secret that corresponds with the environment you would like to connect to.
For example: if you would like to connect to the PostgreSQL DB that is running in the `dev` cluster then select `dcp/upload/dev/database`
3. Go to the `Secret value` box and click on the `Retrieve secret value` button
4. We are interested in the value in the `pgbouncer_uri` field.
You are going to see something similar: `postgresql://username:password@hostname/database_name`
5. Please note down the above 4 values (`username`, `password`, `hostname`, `database_name`) from this field
 
### Using pgAdmin to connect to a RDS for PostgreSQL DB instance

1. Launch the pgAdmin application on your computer.
2. On the Dashboard tab, choose Add New Server.
3. In the Create - Server dialog box, type a name on the General tab to identify the server in pgAdmin.
4. On the Connection tab, type the following information from your DB instance using the 4 values you noted down above:
   1. Add the `hostname` to the `Hostname/address` field
   2. The port is the default value for PostgreSQL DB: 5432
   3. Add the `database_name` to the `Maintenance database` field
   4. Add the `username` to the `Username` field
   5. Add the `password` to the `Password` field
   6. Choose Save.
5. To access a database in the pgAdmin browser, expand Servers, the DB instance, and Databases.
   Choose the DB instance's database name.

   ![](./images/Postgres-Connect02.png)
6. To open a panel where you can enter SQL commands, choose Tools, Query Tool.

There is also an article about how to connect to PostgreSQL DB instances running on AWS here: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ConnectToPostgreSQLInstance.html
