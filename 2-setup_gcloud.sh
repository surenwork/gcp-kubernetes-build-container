#!/bin/bash
echo "Reading deployment variables"
. ~/.build_env

echo "Setting up google cloud enviornment for deployment"
gcloud auth activate-service-account --key-file ${HOME}/gcloud-service-key.json
gcloud config set project $GCLOUD_PROJECT_NAME
gcloud config set compute/region $GCLOUD_REGION
gcloud config set compute/zone $GCLOUD_ZONE
gcloud container clusters get-credentials $GCLOUD_KUBE_CLUSTER
gcloud container clusters update $GCLOUD_KUBE_CLUSTER --no-enable-legacy-authorization

set +e
echo "Creating required core config maps and secrets"
sed -i 's|$APP_PORT|'"$APP_PORT"'|' ${HOME}/nginx.conf
kubectl delete configmap nginx-config
kubectl create configmap nginx-config --from-file=${HOME}/nginx.conf

kubectl delete secret generic service-account-creds
kubectl create secret generic service-account-creds --from-file=${HOME}/gcloud-service-key.json
set -e

echo "Setup complete, Please see the details below"
gcloud config list
