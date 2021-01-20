# Solr

This helm chart installs a Solr cluster and its required Zookeeper cluster into a running
kubernetes cluster.

The chart installs the Solr docker image from: https://hub.docker.com/_/solr/

## Dependencies

- The Bitnami [common](https://github.com/bitnami/charts/tree/master/bitnami/common) helm chart
- The Bitnami [zookeeper](https://github.com/bitnami/charts/tree/master/bitnami/zookeeper) helm chart
- Tested on kubernetes 1.15+

## Installing the Chart

To install the chart with the release name `my-release`:

```bash
helm install my-release preferred-ai/solr
```

The command deploys Solr on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```bash
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

The following table lists the configurable parameters of the Solr chart and their default values.

### Global Configuration

The following table shows the configuration options for the Solr helm chart:

| Parameter                                     | Description                           | Default Value  |
| --------------------------------------------- | ------------------------------------- | -------------- |
| `global.imagePullSecrets`                     | Global Docker registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `image.registry`                              | Solr image registry | `docker.io` |
| `image.repository`                            | The repository to pull the docker image from| `solr` |
| `image.tag`                                   | The tag on the repository to pull | `8.7.0` |
| `image.pullPolicy`                            | Solr pod pullPolicy | `IfNotPresent` |
| `image.pullSecrets`                           | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `service.type`                                | The type of service for the Solr client | `ClusterIP` |
| `service.port`                                | Solr service port | `8983` |
| `service.nodePort`                            | Port to bind to for NodePort and LoadBalancer service types | `""` |
| `service.clusterIP`                           | Solr service cluster IP | `nil` |
| `service.loadBalancerIP`                      | loadBalancerIP for Solr Service | `nil` |
| `service.loadBalancerSourceRanges`            | Address(es) that are allowed when service is LoadBalancer | `[]` |
| `service.externalTrafficPolicy`               | Enable client source IP preservation | `Cluster` |
| `service.annotations`                         | Annotations to apply to the solr client service | `{}` |
| `ingress.enabled`                             | Enable ingress controller resource | `false` |
| `ingress.certManager`                         | Add annotations for cert-manager | `false` |
| `ingress.hostname`                            | Default host for the ingress resource | `solr.local` |
| `ingress.path`                                | Default path for the ingress resource | `/` |
| `ingress.tls`                                 | Create TLS Secret | `false` |
| `ingress.annotations`                         | Ingress annotations | `[]` (evaluated as a template) |
| `ingress.extraHosts[0].name`                  | Additional hostnames to be covered | `nil` |
| `ingress.extraHosts[0].path`                  | Additional hostnames to be covered | `nil` |
| `ingress.extraPaths`                          | Additional arbitrary path/backend objects | `nil` |
| `ingress.extraTls[0].hosts[0]`                | TLS configuration for additional hostnames to be covered | `nil` |
| `ingress.extraTls[0].secretName`              | TLS configuration for additional hostnames to be covered | `nil` |
| `ingress.secrets[0].name`                     | TLS Secret Name | `nil`                          |
| `ingress.secrets[0].certificate`              | TLS Secret Certificate | `nil`                          |
| `ingress.secrets[0].key`                      | TLS Secret Key | `nil`                          |
| `livenessProbe.initialDelaySeconds`           | Initial Delay for Solr pod liveness probe | `20` |
| `livenessProbe.periodSeconds`                 | Poll rate for liveness probe | `10` |
| `livenessProbe.timeoutSeconds`                | When the probe times out | `5`                                                      |
| `livenessProbe.successThreshold`              | Minimum consecutive successes for the probe to be considered successful after having failed. | `1` |
| `livenessProbe.failureThreshold`              | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `6` |
| `readinessProbe.initialDelaySeconds`          | Initial Delay for Solr pod readiness probe | `15` |
| `readinessProbe.periodSeconds`                | Poll rate for readiness probe | `5` |
| `readinessProbe.timeoutSeconds`               | When the probe times out | `5`  |
| `readinessProbe.failureThreshold`             | Minimum consecutive failures for the probe to be considered failed after having succeeded. | `6` |
| `readinessProbe.successThreshold`             | Minimum consecutive successes for the probe to be considered successful after having failed. | `1` |

### Solr Configuration

| Parameter                                     | Description                           | Default Value  |
| --------------------------------------------- | ------------------------------------- | -------------- |
| `port`                                        | The port that Solr will listen on | `8983` |
| `replicaCount`                                | The number of replicas in the Solr statefulset | `3` |
| `javaMem`                                     | JVM memory settings to pass to Solr | `-Xms2g -Xmx3g` |
| `resources`                                   | Resource limits and requests to set on the solr pods | `{}` |
| `extraEnvVars`                                | Additional environment variables to set on the solr pods (in yaml syntax) | `[]` |
| `initScript`                                  | The file name of the custom script to be run before starting Solr | `""` |
| `terminationGracePeriodSeconds`               | The termination grace period of the Solr pods | `180`|
| `podAnnotations`                              | Annotations to be applied to the solr pods | `{}` |
| `affinity`                                    | Affinity policy to be applied to the Solr pods | `{}` |
| `tolerations`                                 | Tolerations to be applied to the Solr pods | `[]` |
| `updateStrategy`                              | The update strategy of the solr pods | `{}` |
| `logLevel`                                    | The log level of the solr pods  | `INFO` |
| `podDisruptionBudget`                         | The pod disruption budget for the Solr statefulset | `{"maxUnavailable": 1}` |
| `schedulerName`                               | The name of the k8s scheduler (other than default)  | `nil` |
| `volumeClaimTemplates.storageClassName`       | The name of the storage class for the Solr PVC | `""` |
| `volumeClaimTemplates.storageSize`            | The size of the PVC | `20Gi` |
| `volumeClaimTemplates.accessModes`            | The access mode of the PVC| `[ "ReadWriteOnce" ]` |
| `tls.enabled`                                 | Whether to enable TLS, requires `tls.certSecret.name` to be set to a secret containing cert details, see README for details | `false` |
| `tls.wantClientAuth`                          | Whether Solr wants client authentication | `false` |
| `tls.needClientAuth`                          | Whether Solr requires client authentication | `false` |
| `tls.keystorePassword`                        | Password for the tls java keystore | `changeit` |
| `tls.importKubernetesCA`                      | Whether to import the kubernetes CA into the Solr truststore | `false` |
| `tls.checkPeerName`                           | Whether Solr checks the name in the TLS certs | `false` |
| `tls.caSecret.name`                           | The name of the Kubernetes secret containing the ca bunble to import into the truststore | `""` |
| `tls.caSecret.bundlePath`                     | The key in the Kubernetes secret that contains the CA bundle | `""` |
| `tls.certSecret.name`                         | The name of the Kubernetes secret that contains the TLS certificate and private key | `""` |
| `tls.certSecret.keyPath`                      | The key in the Kubernetes secret that contains the private key | `tls.key` |
| `tls.certSecret.certPath`                     | The key in the Kubernetes secret that contains the TLS certificate | `tls.crt` |

### Exporter Configuration

| Parameter                                     | Description                           | Default Value  |
| --------------------------------------------- | ------------------------------------- | -------------- |
| `exporter.enabled`                            | Whether to enable the Solr Prometheus exporter | `false` |
| `exporter.image.pullSecrets`                  | Specify docker-registry secret names as an array | `[]` (does not add image pull secrets to deployed pods) |
| `exporter.configFile`                         | The path in the docker image that the exporter loads the config from | `/opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml` |
| `exporter.updateStrategy`                     | Update strategy for the exporter deployment | `{}` |
| `exporter.podAnnotations`                     | Annotations to set on the exporter pods | `{}`
| `exporter.resources`                          | Resource limits to set on the exporter pods | `{}` |
| `exporter.port`                               | The port that the exporter runs on | `9983` |
| `exporter.threads`                            | The number of query threads that the exporter runs | `7` |
| `exporter.livenessProbe.initialDelaySeconds`  | Initial Delay for the exporter pod liveness| `20` |
| `exporter.livenessProbe.periodSeconds`        | Poll rate for liveness probe | `10` |
| `exporter.readinessProbe.initialDelaySeconds` | Initial Delay for the exporter pod readiness | `15` |
| `exporter.readinessProbe.periodSeconds`       | Poll rate for readiness probe | `5` |
| `exporter.service.type`                       | The type of the exporter service | `ClusterIP` |
| `exporter.service.annotations`                | Annotations to apply to the exporter service | `{}` |

### Dependencies Configuration

Please see [Dependencies](#dependencies)

| Parameter                                     | Description                           | Default Value  |
| --------------------------------------------- | ------------------------------------- | -------------- |
| `zookeeper.replicaCount`                      | The number of replicas in the Zookeeper statefulset | `3` |
| `zookeeper.fourlwCommandsWhitelist`           | Four letter words command whitelist | `srvr, mntr, ruok, conf` |

## Service Start with command sets

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```bash
helm install my-release \
--set replicaCount=4,livenessProbe.initialDelaySeconds=90 \
  preferred-ai/solr
```

The above command sets the number of replica to 4, and the liveness probe delay to 90 seconds.

Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,

```bash
helm install my-release -f values.yaml preferred-ai/solr
```

## TLS Configuration

Solr can be configured to use TLS to encrypt the traffic between solr nodes. To set this up with a certificate signed by the Kubernetes CA:

Generate SSL certificate for the installation:

`cfssl genkey ssl_config.json | cfssljson -bare server`

base64 Encode the CSR and apply into kubernetes as a CertificateSigningRequest

```bash
export MY_CSR_NAME="solr-certifiate"
cat <<EOF | ikubectl apply -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: ${MY_CSR_NAME}
spec:
  groups:
  - system:authenticated
  request: $(cat server.csr | base64 | tr -d '\n')
EOF

```

Approve the CSR

`kubectl certificate approve ${MY_CSR_NAME}`

We can now retrieve the approved certificate and save it to `server-cert.pem`

`kubectl get csr "${MY_CSR_NAME}" -o jsonpath='{.status.certificate}'   | base64 --decode  > server-cert.pem`

We store the certificate and private key in a Kubernetes secret:

`kubectl create secret tls solr-certificate --cert server-cert.pem --key server-key.pem`

Now the secret can be used in the solr installation:

`helm install  . --set tls.enabled=true,tls.certSecret.name=solr-certificate,tls.importKubernetesCA=true`

## Upgrading

### To 2.0.0

**What changes were introduced in this major version?**

- Previous versions of this Helm Chart was released in Helm Stable repository. The repository is now deprecated and thus this chart is migrated here.
- This chart uses Bitnami Zookeeper chart as a dependecy instead of Incubator Zookeeper.

**Known Issues**

- You will need to manually move the Zookeeper data files in the current persistent volume when upgrading from 1.x.x. See https://github.com/PreferredAI/helm-charts/issues/5.
- There are error messages in the portal > cloud > zk status. This are cosmetic issues and will not affect the usage. See https://issues.apache.org/jira/browse/SOLR-13801.
