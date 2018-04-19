#!/bin/bash
echo "Update the required enviornment variables for the deployment process"
echo "Reading deployment variables"
. ~/source/.env

HOST_NAME=$APP_NAME.endpoints.$GCLOUD_PROJECT_NAME.cloud.goog
APP_IP_REFERENCE=$APP_NAME-ip
echo "APP_NAME=$APP_NAME" >> .build_env
echo "APP_PORT=$APP_PORT" >> .build_env
echo "APP_TYPE=$APP_TYPE" >> .build_env
echo "HOST_NAME=$HOST_NAME" >> .build_env
echo "APP_IP_REFERENCE=$APP_IP_REFERENCE" >> .build_env
