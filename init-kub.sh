#!/bin/bash

##Install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

##Connect to Cluster
aws sts get-caller-identity
aws-iam-authenticator -i terraform-eks init
aws eks --region us-east-1 update-kubeconfig --name terraform-eks
kubectl get svc
kubectl apply -f aws-auth.yaml


##Export Terraform Data
terraform output kubeconfig > kubeconfig