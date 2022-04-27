#!/bin/bash -e
# install dependencies packages
echo "starting cloud init script . . ."
sudo su
sudo apt-get update
sudo apt install awscli -y

# kubectl
echo "install kubectl . . ."
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# create file
echo "create script folder . . ."
sudo mkdir -p /opt/scripts

# configure aws
echo "config aws account . . ."
aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws eks update-kubeconfig --region ${region} --name ${cluster_name}
sudo kubectl set env daemonset aws-node -n kube-system ENABLE_POD_ENI=true
sudo kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true

%{ if is_config_aws_auth }
echo "config aws-auth . . ."
sudo touch /opt/scripts/eks-manifest-file.yml
sudo chmod 777 /opt/scripts/eks-manifest-file.yml
sudo echo '${eks_manifest_file}' > /opt/scripts/eks-manifest-file.yml
sudo kubectl apply -f /opt/scripts/eks-manifest-file.yml
%{ endif }

sudo shutdown -h now
