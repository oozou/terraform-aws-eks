#!/bin/bash -xe
# install dependencies packages
sudo su
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
sudo kubectl set env daemonset aws-node -n kube-system ENABLE_POD_ENI=true
sudo kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true

%{ if is_config_aws_auth }
sudo touch /opt/scripts/eks-manifest-file.yml
sudo chmod 777 /opt/scripts/eks-manifest-file.yml
sudo echo '${eks_manifest_file}' > /opt/scripts/eks-manifest-file.yml
sudo kubectl apply -f /opt/scripts/eks-manifest-file.yml
%{ endif }

%{ if is_config_aws_lb_controller }
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

%{ if is_config_argo_cd }
sudo touch /opt/scripts/argo-cd-values.yml
sudo chmod 777 /opt/scripts/argo-cd-values.yml
sudo echo '${argo_cd_values}' > /opt/scripts/argo-cd-values.yml
sudo helm repo add argo https://argoproj.github.io/argo-helm
sudo helm repo update
sudo helm upgrade --install argo-cd argo/argo-cd -f /opt/scripts/argo-cd-values.yml  --version 4.2.1
%{ endif }

%{ if is_config_ingress_nginx }
sudo touch /opt/scripts/ingress-nginx-values.yml
sudo chmod 777 /opt/scripts/ingress-nginx-values.yml
sudo echo '${ingress_nginx_values}' > /opt/scripts/ingress-nginx-values.yml
sudo helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
sudo helm repo update
sudo helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -f /opt/scripts/ingress-nginx-values.yml --version 4.0.18
%{ endif }

sudo shutdown -h now
