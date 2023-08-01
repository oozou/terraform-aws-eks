#!/bin/bash -e
# install dependencies packages
echo "starting cloud init script . . ."
sudo su
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg
sudo apt-get update
sudo apt install unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update
sudo apt install jq -y

# kubectl
echo "install kubectl . . ."
curl -LO https://dl.k8s.io/release/v1.27.4/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

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
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true
sudo shutdown -h now
