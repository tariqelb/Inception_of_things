#!/bin/bash
#install and configure k3s server
echo "Start running k3s server installation script...."

#update system
sudo apt-get update
#download k3s as server
curl -sfL https://get.k3s.io | sudo bash -

#Manage your k3s kubernetes using kubectl
#Copy generated configuration file into ~/.kube/config file.

echo "setup kube config----"
#Create local directory for kubeconfig file storage.
sudo mkdir /home/vagrant/.kube
sudo chown vagrant:vagrant  /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown vagrant:vagrant  /home/vagrant/.kube/config
echo 'export KUBECONFIG=/home/vagrant/.kube/config'|tee -a ~/.bashrc
source ~/.bashrc

#Copy token to shared host folder
echo "copy node token ------"
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
sudo chown $USER:$USER  /vagrant/node-token
sudo chmod 777 /vagrant/node-token

#Create the service.
kubectl apply -f /vagrant/config/deploy-nginx.yaml
kubectl apply -f /vagrant/config/nginx-service.yaml

echo "end of k3s server script...."

