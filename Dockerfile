FROM alpine:3.10.2

# install base packages	and add	user
RUN apk add --no-cache \
      bash \
      shadow \
      curl \
      python3 \
      python3-dev	\
      git	\
      jq \
      make \
    && pip3 install --upgrade pip \
    && cd /usr/bin \
    && ln -sf python3 python \
    && ln -sf pip3 pip \
    && pip install awscli \
    && useradd -ms /bin/bash ingest

USER ingest
WORKDIR /home/ingest

RUN mkdir /home/ingest/tools
ENV PATH="/home/ingest/tools:${PATH}"

# install additional tools needed for ingest deployment
RUN cd tools \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.3/bin/linux/amd64/kubectl \
    && wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx \
    && wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens \
    && chmod +x kubectl kubectx kubens \
    && wget https://get.helm.sh/helm-v2.14.3-linux-amd64.tar.gz \
    && tar -zxvf helm-v2.14.3-linux-amd64.tar.gz \
    && mv linux-amd64/* . && rm -rf linux-amd64/ \
    && wget https://releases.hashicorp.com/terraform/0.12.6/terraform_0.12.6_linux_amd64.zip \
    && unzip terraform_0.12.6_linux_amd64.zip \
    && wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.7/2019-06-11/bin/linux/amd64/aws-iam-authenticator \
    && chmod +x aws-iam-authenticator \
    && ln -s aws-iam-authenticator heptio-authenticator-aws

RUN mkdir -p .aws .kube

COPY config .aws
COPY credentials .aws

RUN git clone https://github.com/HumanCellAtlas/ingest-kube-deployment.git
RUN ["/bin/bash", "-c", "cd ingest-kube-deployment && source config/environment_dev && cd infra && make retrieve-kubeconfig-dev"]
RUN ["/bin/bash", "-c", "cd ingest-kube-deployment && source config/environment_integration && cd infra && make retrieve-kubeconfig-integration"]
#RUN ["/bin/bash", "-c", "cd ingest-kube-deployment && source config/environment_staging && cd infra && make retrieve-kubeconfig-staging"]
RUN ["/bin/bash", "-c", "cd ingest-kube-deployment && source config/environment_prod && cd infra && make retrieve-kubeconfig-prod"]
RUN kubectl config get-contexts
