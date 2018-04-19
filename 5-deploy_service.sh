#!/bin/bash
echo "Reading deployment variables"
. ~/.build_env

# Remove existing files from the deployment folder
cd ~/deployment
rm -rf ./*
cd ..

# Check if the type of the application we are deploying is APP if not exit the end point deployment
if [ "$APP_TYPE" != "APP_BASIC" ]; then
  echo "Applicaiton type is not an APP, no need to setup and end point"
  exit 0
fi
TEMPLATE_FOLDER=app_basic # TODO: get this dynamically by converting the $APP_TYPE to lower case

# Copy the service files from the correct template
cp -R ~/templates/$TEMPLATE_FOLDER/* ~/deployment

# Delete the existig services and Deployment
set +e
echo "Delete service and deployment if exists"
kubectl delete service $APP_NAME-service
kubectl delete deployment $APP_NAME-deployment
set -e

# Deploy the service
echo "Creating service for $APP_NAME"
cat ~/deployment/0-service.yml | sed 's|$APP_NAME|'"$APP_NAME"'|' | kubectl create -f -

# Deploy the config maps
echo "Creating config maps for the enviornment variables n $APP_NAME"
for configMapElement in `cat ~/source/.env | sed -r 's/[=]+/:/g'`
do
    echo "  $configMapElement" >> ~/deployment/1-configmap.yml
done
