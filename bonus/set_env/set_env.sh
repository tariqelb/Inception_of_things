#!/bin/bash


#Installation script
#bash instalation_scrip.sh

#Start cluster
bash ./set_env/set_cluster.sh

#Start gitlab
bash ./set_env/set_gitlab.sh

#Start argocd
bash ./set_env/set_argocd.sh
