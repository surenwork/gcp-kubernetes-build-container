#!/bin/bash
echo "Setting up google cloud enviornment for deployment"
cat ${HOME}/gcloud-service-key.json
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
gcloud config set project $GCLOUD_PROJECT_NAME
gcloud config set compute/region $GCLOUD_REGION
gcloud config set compute/zone $GCLOUD_ZONE
echo "Setup complete, Please see the details below"
gcloud config list
