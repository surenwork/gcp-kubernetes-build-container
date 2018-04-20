#!/bin/bash
echo "Reading deployment variables"
. ~/.build_env

# Check if the type of the application we are deploying is APP if not exit the end point deployment
if [ "$APP_TYPE" != "APP_BASIC" ]; then
  echo "Applicaiton type is not an APP, no need to setup and end point"
  exit 0
fi

# Define all script variables here

set +e
echo "Creating application static IP, if not exists"
gcloud compute addresses create $APP_IP_REFERENCE --global
set -e

SERVER_IP=$(gcloud compute addresses describe $APP_IP_REFERENCE --global | grep address: | cut -d':' -f 2 | xargs)


echo "Updating open-api configuration file"
sed -i 's|$APP_NAME|'"$APP_NAME"'|' ~/source/openapi.yaml
sed -i 's|$HOST_NAME|'"$HOST_NAME"'|' ~/source/openapi.yaml
sed -i 's|$SERVER_IP|'"$SERVER_IP"'|' ~/source/openapi.yaml

gcloud endpoints services deploy ~/source/openapi.yaml
ENDPOINT_CONFIG_ID=$(gcloud endpoints configs list --service=$HOST_NAME --limit=1 --format="value(id)")

echo "Updating enviornment variables"
echo "SERVER_IP=$SERVER_IP" >> ~/.build_env
echo "ENDPOINT_CONFIG_ID=$ENDPOINT_CONFIG_ID" >> ~/.build_env

echo "Updated .build_env"
cat ~/.build_env
