FROM python:3.6.9-alpine
LABEL maintainer="Sudipt Sharma<sudipt.sharma@opstree,com>"
RUN pip install --upgrade pip && \
    pip3 install boto3 && \
    pip3 install pyhcl && \
    pip3 install awscli

ENV TERRAFORM_VERSION=0.12.21

RUN echo "===> Installing Terraform..." 
RUN apk update && \
    apk add curl && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/local/bin/. && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip  
