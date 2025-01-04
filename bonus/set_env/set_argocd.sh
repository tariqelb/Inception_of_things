#!/bin/bash

#Apply crds
echo "------- apply argocd crds ------"
kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref\=stable

#Setup argocd project and application
echo "----------------- setup argocd project and application -----------"
kubectl apply -f config/argocd.yaml

sleep 5

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 10


#Define argocd service
kubectl apply -f config/argocd_service.yaml

#Get argocd password 
echo "password to access argocd account (admin) : "
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d ; echo

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

#Strat argocd server on localhost 8888
#echo "----- start argocd server --- "
#kubectl port-forward svc/argocd-server -n argocd 8081:80 &
