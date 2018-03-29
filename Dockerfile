FROM ubuntu

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongodb-clients

RUN pip install awscli

RUN mkdir -p /data/db/dump

COPY src/monitor-backup.sh /opt/backup

RUN chmod +x /opt/backup

ENTRYPOINT /opt/backup
