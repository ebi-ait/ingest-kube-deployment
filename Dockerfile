FROM ubuntu

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongodb-clients

RUN pip install awscli

VOLUME /data/sync

COPY src/monitor-backup.sh /opt/backup

RUN chmod +x /opt/backup

ENTRYPOINT /opt/backup
