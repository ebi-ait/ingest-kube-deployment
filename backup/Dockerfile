FROM ubuntu

RUN apt-get update && \
    apt-get install -y apt-transport-https

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5 && \
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-3.6.list

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongodb-org-tools

RUN pip install awscli

RUN mkdir -p /data/db/dump

COPY src/backup.sh /opt/backup

RUN chmod +x /opt/backup

ENTRYPOINT /opt/backup
