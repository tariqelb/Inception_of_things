#!/bin/bash

# Prompt the user for sudo password instead of hardcoding
read -sp "Enter sudo password: " Password
echo

#Delete k3s cluster
echo "----- Delete k3s cluster ---------"
k3d cluster delete mycluster
#k3d cluster delete --all

# Uninstall Docker Desktop
#echo $Password | sudo -S apt purge -y docker-desktop

# Uninstall Docker Engine (docker-ce) and related components
echo "------------------ Remove docker engine and cli ... ------------------------"
echo $Password | sudo -S apt purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Remove Docker-related files
echo $Password | sudo -S rm -rf $HOME/.docker
echo $Password | sudo -S rm -rf ./docker.gpg
echo $Password | sudo -S rm -rf /var/lib/docker
echo $Password | sudo -S rm -rf /var/lib/containerd
echo $Password | sudo -S rm -f /usr/local/bin/com.docker.cli

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y

echo "Docker and all related components have been successfully uninstalled!"

# Uninstall kubectl
echo "--------------------- Removing kubectl binary ---------------------------"
echo $Password | sudo -S rm -f /usr/local/bin/kubectl

# Remove configuration files
echo "--------------------- Removing kubectl config files ---------------------"
echo $Password | sudo -S rm -rf $HOME/.kube

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y

echo "kubectl has been successfully uninstalled!"


# Remove K3D binary
echo "--------------------- Removing K3D binary ---------------------------"
echo $Password | sudo -S rm -f /usr/local/bin/k3d

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y

echo "K3D has been successfully uninstalled!"


# Remove argocd binary
echo  "------------------- Removing argocd ---------------------"
echo $Password | sudo -S rm -f /usr/local/bin/argocd

#Remove config
rm -rf ~/.argocd

# Perform cleanup
echo $Password | sudo -S apt autoremove -y
echo $Password | sudo -S apt autoclean -y


#uninstall Helm
echo "---------- removing Helm ----------------"
echo $Password | sudo -S rm -f /usr/local/bin/helm
rm -rf ~/.config/helm
rm -rf ~/.cache/helm
rm -rf ~/.local/share/helm


echo "Argocd uninstalled"

