#!/bin/bash -e
# install dependencies packages
echo "starting cloud init script . . ."
sudo su
sudo apt-get update
sudo apt install awscli -y
sudo apt install jq -y

# kubectl
echo "install kubectl . . ."
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl=1.23.4-00

# create file
echo "create script folder . . ."
sudo mkdir -p /opt/scripts

# configure aws
echo "config aws account . . ."
aws configure set region ${region}
credential=$(aws secretsmanager get-secret-value  --secret-id ${eks_bootstrap_secret_arn} --query SecretString --output text)
aws_access_key_id=$(echo $credential | jq '.aws_access_key_id' | tr -d '"')
aws_secret_access_key=$(echo $credential | jq '.aws_secret_access_key' | tr -d '"')
export AWS_ACCESS_KEY_ID=$aws_access_key_id
export AWS_SECRET_ACCESS_KEY=$aws_secret_access_key
aws eks update-kubeconfig --region ${region} --name ${cluster_name}
%{ if is_config_aws_auth }
echo "config aws-auth . . ."
sudo touch /opt/scripts/eks-manifest-file.yml
sudo chmod 777 /opt/scripts/eks-manifest-file.yml
sudo echo '${eks_manifest_file}' > /opt/scripts/eks-manifest-file.yml
sudo AWS_ACCESS_KEY_ID=$aws_access_key_id AWS_SECRET_ACCESS_KEY=$aws_secret_access_key kubectl apply -f /opt/scripts/eks-manifest-file.yml
%{ endif }

sudo shutdown -h now
