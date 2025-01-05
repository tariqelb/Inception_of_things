#!/bin/bash

#Start up K3s cluster and start argocd server
#Get Password
#read -sp "Enter sudo password: " Password
#echo

#Delete virtual network interface
#echo $Password | sudo -S ip link set eth001 down
#echo $Password | sudo -S ip link delete eth001
#Create new virtual network interface
#echo $Password | sudo -S ip link add eth001 type veth peer name eth001-peer
#echo $Password | sudo ip addr add 192.168.56.110/24 dev eth001
#echo $Password | sudo ip link set eth001 up

#create a custom docker network
#docker network rm my-custom-network
#docker network create   --subnet=192.168.56.0/24 --gateway=192.168.56.1 my-custom-network


#Create a cluster with k3d utility
echo "--------- create ks3 cluster with k3d --------------"
#k3d cluster create mycluster --network my-custom-network --api-port "192.168.56.1:6443"
k3d cluster create mycluster

#Add two namespaces dev and argocd 
echo "------ create namespaces -----------------------"
kubectl apply -f config/manifest/argcd-namespace.yaml
kubectl apply -f config/manifest/dev-namespace.yaml

sleep 5

INTERNAL_IP=$(kubectl get nodes -o wide --no-headers | awk '{print $6}')

# Define argocd and gitlab hosts
line1="$INTERNAL_IP app1.com app2.com app3.com"
line2="$INTERNAL_IP gitlab.xip.io"

# Check if the first line exists, if not, append it
if ! grep -Fxq "$line1" /etc/hosts; then
  echo "$line1" | sudo tee -a /etc/hosts > /dev/null
  echo "Added: $line1"
else
  echo "Already exists: $line1"
fi

# Check if the second line exists, if not, append it
if ! grep -Fxq "$line2" /etc/hosts; then
  echo "$line2" | sudo tee -a /etc/hosts > /dev/null
  echo "Added: $line2"
else
  echo "Already exists: $line2"
fi

