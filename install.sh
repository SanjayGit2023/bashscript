#!/bin/bash
set -e

# Update package index
sudo apt update -y

# Install necessary packages
sudo apt install -y unzip curl gnupg apt-transport-https

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify AWS CLI installation
aws --version

# Configure AWS CLI with access keys
aws configure set aws_access_key_id 
aws configure set aws_secret_access_key 
aws configure set default.region ap-south-1
aws configure set default.output json

# Verify AWS CLI configuration
aws configure list
aws sts get-caller-identity

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Verify kubectl installation
kubectl version --client

# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/
sudo chmod +x /usr/local/bin/eksctl

# Verify eksctl installation
eksctl version

# Create EKS cluster (2 nodes)
eksctl create cluster --name demo-cluster --region ap-south-1 --nodes 2

# Update kubeconfig to use the new cluster
aws eks update-kubeconfig --name demo-cluster --region ap-south-1
