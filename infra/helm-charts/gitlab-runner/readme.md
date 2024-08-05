Helm chart for gitlab runner.
=============================

See [gitlab docs](https://docs.gitlab.com/15.11/runner/install/kubernetes.html)

The chart uses the `aws-keys` secret to acquire the gitlab runner registration token.

Troubleshooting:

- runner fails to start - check pod logs
- When gitlab is upgraded (follow [#gitlab](https://ebi.enterprise.slack.com/archives/CB441ME9X) and [#announcements](https://ebi.enterprise.slack.com/archives/CJG9W3F32) channels on slack), make sure chart version is compatible with gitlab app version. Serach for the matching
  version by running the following command.
```bash
helm repo update
helm search repo -l gitlab/gitlab-runner
```
- upgrade the chart version in `Chart.yaml` and run
```bash
cd infra
make install-infra-helm-chart-gitlab-runner
```
- in case there are errors, you might need to clean up some k8s objects manually
