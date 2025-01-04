#!/bin/bash

# Install GitLab
#Get master node internal IP address
INTERNAL_IP=$(kubectl get nodes -o wide --no-headers | awk '{print $6}')

#Define gitlab namespace
kubectl apply -f config/manifests/gitlab-namespace.yaml

#Install getlab
helm upgrade --install gitlab gitlab/gitlab -n gitlab \
        -f config/value-minikube.yaml \
        --set global.hosts.domain=gitlab.xip.io \
        --set global.hosts.externalIP=$INTERNAL_IP \
	--set global.hosts.https=false \
        --timeout 600s

sleep 5

#Wait until pods ready
echo "wait until all pods are ready (runnig) max 5 min"
kubectl wait --for=condition=Ready pods --all -n gitlab --timeout=300s

#forward port to access gitlab service from localhost:8080 (check if all pod running)
kubectl port-forward -n gitlab svc/gitlab-webservice-default  8080:8181 &

#Display gitlab password (admin = root)
# Set green color
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Print URL in green
echo -e "${GREEN}Url : http://localhost:8080${NC}"

# Print information about the admin user
echo -e "${GREEN}Display GitLab password (admin = root)${NC}"

# Fetch and display the GitLab root password in green
echo -ne "${GREEN}Password : ${NC}"
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode
echo
echo


echo "Visit http://localhost:8080 use root as username and password typed above"
echo "Create new public repository, with project name/slag (inception-of-things), and user (root)"
echo "After creating the repository, press Enter to continue"
echo "Then push config/manifest directory to repository"

echo "git init"
echo "git add config/manifest"
echo "git commit -m 'App deployment'"
echo "git remote add origin http://localhost:8080/root/inception-of-things"
echo "git push -uf origin master"
echo "rm -rf .git"

# Pause and wait for user to press Enter
read -p "Press Enter to continue..." 
