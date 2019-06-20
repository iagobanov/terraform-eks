#!/bin/bash

##Create Cluster
cd $HOME/terraform-eks/cluster
terraform init
terraform apply --auto-approve 

##Export Terraform Data
cd $HOME/terraform-eks/cluster && terraform output config-map-aws-auth > $HOME/terraform-eks/kubernetes/aws-auth.yaml
cd $HOME/terraform-eks/cluster && terraform output kubeconfig > $HOME/terraform-eks/kubernetes/kubeconfig
cd $HOME/terraform-eks/kubernetes && sed -i 's/heptio-authenticator-aws/aws-iam-authenticator/g' kubeconfig


##Install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

##Connect to Cluster
aws sts get-caller-identity
aws-iam-authenticator -i gc-demo init
aws eks --region us-east-1 update-kubeconfig --name gc-demo
kubectl get svc

#Run authentication
export KUBECONFIG=kubeconfig
kubectl get all
cd $HOME/terraform-eks/kubernetes && sleep 10 && kubectl apply -f aws-auth.yaml

##Create Nginx Application
cd $HOME/terraform-eks/kubernetes
terraform init
terraform apply --auto-approve