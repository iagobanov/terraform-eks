#!/bin/bash

##Export Terraform Data
terraform output kubeconfig
terraform output kubeconfig > ${HOME}/.kube/config-eksworkshop-tf
export KUBECONFIG=${HOME}/.kube/config-eksworkshop-tf:${HOME}/.kube/config
echo "export KUBECONFIG=${KUBECONFIG}" >> ${HOME}/.bashrc
terraform output config-map
terraform output config-map > /tmp/config-map-aws-auth.yml

##Install aws-iam-authenticator
curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator
curl -o aws-iam-authenticator.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator.sha256
openssl sha1 -sha256 aws-iam-authenticator
chmod +x ./aws-iam-authenticator
mkdir -p $HOME/bin && cp ./aws-iam-authenticator $HOME/bin/aws-iam-authenticator && export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc

##Connect to Cluster
aws sts get-caller-identity
aws-iam-authenticator -i gc-cluster init
aws eks --region us-east-1 update-kubeconfig --name gc-cluster
kubectl get svc


##Run Application Tests
# kubectl apply -f https://k8s.io/examples/application/deployment.yaml