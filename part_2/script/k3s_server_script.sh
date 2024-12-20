#!/bin/bash
#install and configure k3s server
echo "Start running k3s server installation script...."

#update system
sudo apt-get update
#download k3s as server
#curl -sfL https://get.k3s.io | sudo bash -
ServerIP=192.168.56.110
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=$ServerIP --advertise-address=$ServerIP --bind-address=$ServerIP --tls-san=$ServerIP" sh -

#Manage your k3s kubernetes using kubectl
#Copy generated configuration file into ~/.kube/config file.

echo "setup kube config----"
#Create local directory for kubeconfig file storage.
sudo mkdir -p /home/vagrant/.kube
sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube



#copy ssh private key to server so it can connnect to agent by ssh 
#The reason is to copy k3s.yaml to set kubectl

#change /etc/rancher/k3s/k3s.yaml file owner to vagrant default user
sudo chown vagrant:vagrant /etc/rancher/k3s/k3s.yaml


#This piece of code don't work as expected so i do change /etc/rancher/k3s/k3s.yaml file owner
# Export KUBECONFIG in the current session
export KUBECONFIG=/home/vagrant/.kube/config

# Add KUBECONFIG to .bashrc
if ! grep -q "export KUBECONFIG=/home/vagrant/.kube/config" ~/.bashrc; then
	echo "export KUBECONFIG=/home/vagrant/.kube/config" | sudo tee -a ~/.bashrc
fi

# Reload .bashrc to apply changes
source ~/.bashrc

# Attempt to export KUBECONFIG in a loop

echo "Verifying KUBECONFIG export..."
while true; do
    # Check if ~/.bashrc contains the KUBECONFIG export line
    if grep -q "export KUBECONFIG=/home/vagrant/.kube/config" ~/.bashrc; then
        echo "KUBECONFIG line exists in ~/.bashrc."
        source ~/.bashrc
        break
    else
        echo "KUBECONFIG line not found in ~/.bashrc. Adding it..."
	export KUBECONFIG=/home/vagrant/.kube/config
        echo "export KUBECONFIG=/home/vagrant/.kube/config" | sudo tee -a ~/.bashrc
        source ~/.bashrc
    fi
    sleep 2
done

echo "KUBECONFIG successfully configured in ~/.bashrc and sourced."

kubectl apply -f /vagrant/config/app01_page_configMap.yaml 
kubectl apply -f /vagrant/config/app02_page_configMap.yaml 
kubectl apply -f /vagrant/config/app03_page_configMap.yaml 

kubectl apply -f /vagrant/config/app_01_deployment.yaml
kubectl apply -f /vagrant/config/app_02_deployment.yaml
kubectl apply -f /vagrant/config/app_03_deployment.yaml

kubectl apply -f /vagrant/config/app_01_service.yaml
kubectl apply -f /vagrant/config/app_02_service.yaml
kubectl apply -f /vagrant/config/app_03_service.yaml

kubectl apply -f /vagrant/config/apps_ingress.yaml

echo "end of k3s server script...."

