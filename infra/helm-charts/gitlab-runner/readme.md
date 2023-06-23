Helm chart for gitlab runner.
=============================

See [gitlab docs](https://docs.gitlab.com/15.11/runner/install/kubernetes.html)

The chart uses the `aws-keys` secret to acquire the gitlab runner registration token.

Troubleshooting:

- runner fails to start - check pod logs
- When gitlab is upgraded, make sure chart version is compatible with gitlab app version. Serach for the matching
  version by running the following command.
```bash
helm search repo -l gitlab/gitlab-runner
```