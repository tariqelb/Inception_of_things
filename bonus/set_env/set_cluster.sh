#!/bin/bash




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

