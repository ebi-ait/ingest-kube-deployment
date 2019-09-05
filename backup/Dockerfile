FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongo-tools && \
    pip install awscli

RUN mkdir -p /data/db/dump

COPY src/backup.sh /opt/backup

RUN chmod +x /opt/backup

ENV S3_BUCKET=ingest-backup
ENV BACKUP_DIR=deploymentenv

ENTRYPOINT /opt/backup
