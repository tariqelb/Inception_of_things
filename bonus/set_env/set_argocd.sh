#!/bin/bash

#Apply crds
echo "------- apply argocd crds ------"
kubectl apply -n argocd -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable

sleep 5
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
sleep 5

#Setup argocd project and application
echo "----------------- setup argocd project and application -----------"
kubectl apply -f config/argocd.yaml

sleep 10


#Define argocd service
kubectl apply -f config/argocd_service.yaml
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Get ArgoCD password
echo -e "${GREEN}Password to access ArgoCD account (admin): ${NC}"
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
echo -e "\n${GREEN}--------------------------------------------------${NC}"

# Instructions for accessing ArgoCD UI
echo -e "${GREEN}----------------For accessing ArgoCD UI-------------------${NC}"
echo -e "${GREEN}1. Get master node internal IP address and ArgoCD service node port:${NC}"
echo -e "${GREEN}   kubectl get nodes -o wide${NC}"
echo -e "${GREEN}   kubectl get svc -n argocd${NC}"
echo -e "${GREEN}2. Take ArgoCD service NodePort (e.g., 30XXX).${NC}"
echo -e "${GREEN}3. Navigate to http://<NODE_IP>:<PORT>${NC}"
echo -e "${GREEN}   Username: admin${NC}"
echo -e "${GREEN}   Password: Printed above.${NC}"
echo -e "${GREEN}--------------------------------------------------${NC}"

#Forword application to localhost port 8888
sleep 5
while true; do
    # Check if the service exists in the dev namespace
    if ! kubectl get service app-service -n dev > /dev/null 2>&1; then
        echo "Resource app-service not yet ready ...."
    else
        # Forward port once the service is ready
        echo "Resource app-service is ready |-.-|"
    	sleep 10
        kubectl port-forward svc/app-service -n dev 8888:80 &
        break
    fi
    # Wait 10 seconds before checking again
    sleep 10
done


