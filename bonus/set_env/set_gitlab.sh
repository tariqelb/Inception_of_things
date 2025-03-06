#!/bin/bash

#Add the GitLab Helm repo 
helm repo add gitlab https://charts.gitlab.io

# Install GitLab
#Get master node internal IP address
INTERNAL_IP=$(kubectl get nodes -o wide --no-headers | awk '{print $6}')

#Define gitlab namespace
kubectl apply -f config/manifest/gitlab-namespace.yaml

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
GR='\044[0;42m'
NC='\033[0m' # No Color

# Print URL in green
echo -e "${GREEN}Url : http://localhost:8080${NC}"

# Print information about the admin user
echo -e "${GREEN}Display GitLab password (username = root)${NC}"

# Fetch and display the GitLab root password in green
echo -ne "${GREEN}Password : "
kubectl get secret gitlab-gitlab-initial-root-password -n gitlab -ojsonpath='{.data.password}' | base64 --decode
echo 
echo -e "${GREEN}.${NC}"


echo -e "${GREEN}Visit http://localhost:8080 use root as username and password typed above${NC}"
echo -e "${GREEN}Create new public repository, with project name/slag (inception-of-things), and user (root)${NC}"
echo -e "${GREEN}After creating the repository, press Enter to continue${NC}"
echo -e "${GREEN}Then push config/manifest directory to repository${NC}"

echo -e "${GREEN}Open a new terminal window${NC}"
echo -e "${GREEN}cd config${NC}"
echo -e "${GREEN}git init${NC}"
echo -e "${GREEN}git add manifest${NC}"
echo -e "${GREEN}git commit -m 'App deployment'${NC}"
echo -e "${GREEN}git remote add origin http://localhost:8080/root/inception-of-things${NC}"
echo -e "${GREEN}git push -u origin master${NC}"
echo -e "${GREEN}rm -rf .git${NC}"
echo -e "${GREEN}The username and password is printed above${NC}"
echo -e "${GREEN}After finish press enter to setup arcgcd.${NC}"

# Pause and wait for user to press Enter
read -p $'Press Enter to continue...\n' 
