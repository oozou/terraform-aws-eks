#!/bin/bash -xe
# install dependencies packages
sudo apt-get update
sudo apt install awscli -y

# kubectl
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl

# helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
sudo apt-get install apt-transport-https --yes
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

# create file
sudo mkdir -p /opt/scripts


# configure aws
aws configure set aws_access_key_id ${aws_access_key_id}
aws configure set aws_secret_access_key ${aws_secret_access_key}
aws eks update-kubeconfig --region ${region} --name ${cluster_name}

%{ if config_aws_auth }
sudo touch /opt/scripts/eks-manifest-file.yml
sudo chmod 777 /opt/scripts/eks-manifest-file.yml
sudo echo '${eks_manifest_file}' > /opt/scripts/eks-manifest-file.yml
sudo kubectl apply -f /opt/scripts/eks-manifest-file.yml
%{ endif }

%{ if config_aws_lb_controller }
sudo touch /opt/scripts/aws-lb-controller-sa.yml
sudo chmod 777 /opt/scripts/aws-lb-controller-sa.yml
sudo echo '${aws_lb_controller_sa}' > /opt/scripts/aws-lb-controller-sa.yml
sudo kubectl apply -f /opt/scripts/aws-lb-controller-sa.yml

sudo helm repo add eks https://aws.github.io/eks-charts
sudo helm repo update
sudo helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=test-environment \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --version 1.4.0
%{ endif }

sudo shutdown -h now
