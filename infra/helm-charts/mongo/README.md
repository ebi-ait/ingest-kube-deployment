# Ingest MongoDB

## Introduction
This chart installs MongoDB along with a periodic database backup and verification cron-job.

## TL;DR
```bash
$ ./setup.sh <environment name>
```

## Installation pre-requisites
The `backup` chart depends on AWS credentials for storing database backups in AWS S3 storage. These should be located in the AWS secret-manager service at dcp/ingest/<env>/mongo-backup/s3-access, with the following format:

```javascript
{
  "access_key_id": ... ,
  "access_key_secret": ...

}
```

The principal associated with the access key should have read and write access to the `ingest-backup` S3 bucket located in the pre-prod HCA AWS account.

A slack webhook URL is also expected, so that the backup jobs can notify interested slack channels.

## Installation

1. Ensure you are pointing to the correct environment cluster:
```bash
$ . ../../../config/environment_<environment>
```
2. Install with helm :

```bash
# assuming prod cluster
helm upgrade mongo ./ --wait --install --force -f values.yaml -f environments/prod.yaml --set ingestbackup.secret.aws.accessKey=<provide access key id>,ingestbackup.secret.aws.secretAccessKey=<provide access key secret>,ingestbackup.verification.slack.webhookUrl=<provide slack alert webhook url>
```  
