# Populating firstDcpVersion and dcpVersion of DCP1 metadata

The script `populate_dcp_version.py` fixes the missing `dcpVersion` values in the metadata documents in the Ingest database. It reads `dcp1-metadata.txt.tar.gz`  which is the compressed file that contains the list of all the metadata json files in the DCP1 terra bucket `gs://broad-dsp-monster-hca-prod-ucsc-storage/prod/no-analysis/metadata`.

Please see issue: https://github.com/ebi-ait/dcp-ingest-central/issues/481

## How to build docker image and push to quay.io?

```bash
docker build . -t quay.io/ebi-ait/ingest-kube-deployment:dcp1-version_20211102.1
docker push quay.io/ebi-ait/ingest-kube-deployment:dcp1-version_20211102.1

## How to run inside ingest cluster?
Source environment config and set correct environment context 
```
$ source config/environment-dev
$ kubectx ingest-eks-dev
```

To create the job and run inside the cluster
```
$ helm install dcp1-version . --values ./values.yaml
```

To check/monitor the logs:

```
# find the pod name first
$ kubectl get pods | grep dcp1-version
dcp1-version-lgmj2                                      1/1     Running     0          22s

# follow logs
$ kubectl logs -f dcp1-version-lgmj2
<logs>
```

To delete the job

```
helm delete dcp1-version
```

Note: It is not possible to update the job spec template (which contains the job image) in Kubernetes. Please see comment in GH issue: [Cannot upgrade a release with Job](https://github.com/helm/helm/issues/7725#issuecomment-617373825) and a related [stackoverflow question](https://stackoverflow.com/questions/57178909/changing-image-of-kubernetes-job)
