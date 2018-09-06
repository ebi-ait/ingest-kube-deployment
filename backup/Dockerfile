FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongodb-clients && \
    pip install awscli

RUN mkdir -p /data/db/dump

COPY src/backup.sh /opt/backup

RUN chmod +x /opt/backup

ENTRYPOINT /opt/backup
