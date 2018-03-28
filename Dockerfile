FROM python:3.6-alpine

RUN apk update && \
    apk add inotify-tools

RUN pip install awscli

VOLUME /data/sync

ENV S3_BUCKET ""

COPY src/monitor-backup.sh /opt/monitor

RUN chmod +x /opt/monitor

ENTRYPOINT /opt/monitor
