#!/bin/bash
echo "Reading deployment variables"
. ~/.build_env

# Check if the type of the application we are deploying is APP if not exit the end point deployment
if [ "$APP_TYPE" != "APP_BASIC" ]; then
  echo "Applicaiton type is not an APP, no need to setup and end point"
  exit 0
fi

# Delete the existig services and Deployment
set +e
echo "Delete the existing certification service"
kubectl delete service ngk-certification-service
kubectl delete deployment ngk-certification-deployment
set -e

# Deploy the service
echo "Creating service for ngk-certification"
kubectl create -f ~/support-services/ngk-certification/0-service.yml

# Deploy the pod
echo "Create the deployment for ngk-certification"
cat ~/support-services/ngk-certification/1-deployment.yml | sed 's|$HOST_NAME|'"$HOST_NAME"'|' | kubectl create -f -

# Verify the ability to access the files

# User certbot to obtain the certification

# Create the kube secrets from the obtained tls certificate files under the $APP_NAME

# Remove the ngk-certification deployment
