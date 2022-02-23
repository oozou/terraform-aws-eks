sudo apt-get update
sudo apt install awscli -y
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubectl
export AWS_SECRET_ACCESS_KEY=${aws_secret_access_key}
export AWS_ACCESS_KEY_ID=${aws_access_key_id}
aws eks update-kubeconfig --region ${region} --name ${cluster_name}
kubectl apply -f /etc/scripts/aws-auth.yml
kubectl apply -f /etc/scripts/dev_role.yml
kubectl apply -f /etc/scripts/dev_role_binding.yml
kubectl apply -f /etc/scripts/qa_role.yml
kubectl apply -f /etc/scripts/aws-auth.yml
kubectl apply -f /etc/scripts/qa_role_binding.yml
# sudo shutdown -h now