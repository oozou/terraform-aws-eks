#!/bin/bash -xe
# install dependencies packages
sudo apt-get update
sudo apt install awscli -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl


sudo mkdir -p /opt/scripts
sudo touch /opt/scripts/eks-manifest-file.yml
sudo chmod 777 /opt/scripts/eks-manifest-file.yml
sudo echo '${eks_manifest_file}' > /opt/scripts/eks-manifest-file.yml

# configure aws
aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws eks update-kubeconfig --region ${region} --name ${cluster_name}
sudo kubectl apply -f /opt/scripts/eks-manifest-file.yml
# sudo shutdown -h now
