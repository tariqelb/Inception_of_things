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

#Copy token to shared host folder
echo "copy node token ------"
sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/node-token
sudo chown $USER:$USER  /vagrant/node-token
sudo chmod 777 /vagrant/node-token

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

#copy kubectl config file to shared folder for the agent kubectl setup
sudo cat /home/vagrant/.kube/config > /vagrant/config/kubeconfig

echo "end of k3s server script...."

