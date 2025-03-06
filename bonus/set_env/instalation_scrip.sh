#!/bin/bash

User=tariq
#Get Password
read -sp "Enter sudo password: " Password
echo

###Install Docker on linux ubuntu

#Upadate system
echo "---------------- Update system ---------------------------------"
echo $Password | sudo -S apt update

#Install dependencies
echo "---------------- Install dependencies --------------------------"
echo $Password | sudo -S apt install apt-transport-https ca-certificates curl software-properties-common

#Download Docker gpg key
echo "---------------- Download docker gpg key -----------------------"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o docker.gpg

#Add Docker gpg key to system keyring
echo "---------------- Add docker gpg key to system keyring-----------"
echo $Password | sudo -S apt-key add docker.gpg
rm ./docker.gpg

#Install Docker repository to APT source
echo "---------------- Install docker repo to APT source -------------"
echo $Password | sudo -S add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

#Install Docker
echo "---------------- Install Docker --------------------------------"
echo $Password | sudo -S apt install docker-ce -y

#Add user to Docker group
echo "---------------- Add user to docker group , this action needs a logout to take effect ----------"
echo $Password | sudo -S usermod -aG docker $User

#Docker version
docker --version
echo "--------------------- installation process of Docker complete --------------------------"

###Install kubectl utility 

#Download kubectl
echo "--------------------- Download kubectl ---------------------------"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

#Add permission
echo "--------------------- Add permission to kubectl -------------------"
chmod +x ./kubectl

#Move the kubectl to right location
echo "--------------------- move kubectl to /usr/local/bin/kubectl  -----------------"
sudo mv ./kubectl /usr/local/bin/kubectl

#Kubectl sersion
echo "------------------ kubectl version ------------------------------"
kubectl version

###Install K3D 

#Download and install K3D
echo "-------------------- Download and execute K3d installation --------------------"
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

#K3D version
echo "-------------------- k3D version ---------------------------------"
k3d --version

### Install Argo CD CLI
echo "----------------- Installing Argo CD CLI... -----------------------"
curl -sSL -o argocd https://github.com/argoproj/argo-cd/releases/download/v2.5.3/argocd-linux-amd64

#Add permission to excutable
chmod +x argocd

#Move argocd exec to bin
echo $Password | sudo -S mv argocd /usr/local/bin/

#install Helm
echo "--------------- Install Helm -------------------"
echo $Password | sudo -S curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
echo $Password | sudo -S chmod 700 get_helm.sh
echo $Password | sudo -S ./get_helm.sh
echo $Password | sudo -S helm repo add gitlab https://charts.gitlab.io
echo $Password | sudo -S helm repo update

#Restart Docker
echo "----- Restarting docker service... -----"
echo $Password | sudo -S systemctl restart docker

sleep 5
echo "---------- instalation script finish  -----------"
