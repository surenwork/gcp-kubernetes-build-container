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
