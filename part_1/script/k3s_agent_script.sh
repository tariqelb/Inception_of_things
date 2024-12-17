#!/bin/bash
#install and configure k3s agent

#store node-token in a variable
NodeToken=$(sudo cat /vagrant/node-token)

ServerIP="192.168.56.110"
AgentIP="192.168.56.111"

#Download k3s as agent
#curl -sfL https://get.k3s.io | sudo K3S_URL=https://$ServerIP:6443 K3S_TOKEN=$NodeToken sh -
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=$AgentIP" K3S_URL=https://$ServerIP:6443 K3S_TOKEN=$NodeToken sh -

#copy ssh private key to agent so it can connnect to server by ssh 
#The reason is to copy k3s.yaml to set kubectl

sudo mkdir /home/vagrant/.kube
sudo chown vagrant:vagrant /home/vagrant/.kube

#not work because connection not yet established 
#scp -F /vagrant/script/ssh_config vagrant@TariqServer:/home/vagrant/.kube/config /home/vagrant/.kube/config
#so we will use the hard way
sudo mv /vagrant/config/kubeconfig /home/vagrant/.kube/config 

export KUBECONFIG=/home/vagrant/.kube/config
echo "export KUBECONFIG=/home/vagrant/.kube/config" | sudo tee -a ~/.bashrc
source ~/.bashrc

echo "Waiting for node to join the cluster..."
sleep 15
echo "Node is ready!"

#Create the service.
kubectl apply -f /vagrant/config/deploy-nginx.yaml
kubectl apply -f /vagrant/config/nginx-service.yaml


echo "end of k3s agent script...."

