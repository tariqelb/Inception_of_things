#!/bin/bash
#install and configure k3s agent

#store node-token in a variable
NodeToken=$(sudo cat /vagrant/node-token)

ServerIP="192.168.56.110"

#Download k3s as agent
curl -sfL https://get.k3s.io | sudo K3S_URL=https://$ServerIP:6443 K3S_TOKEN=$NodeToken sh -



echo "end of k3s agent script...."

