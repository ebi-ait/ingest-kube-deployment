FROM ubuntu

RUN apt-get update && \
    apt-get install -y python3 python-pip && \
    apt-get install -y mongodb-clients && \
    apt-get install -y groff

RUN pip install awscli
