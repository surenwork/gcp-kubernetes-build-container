#!/bin/bash
echo "Reading deployment variables"
. ~/.build_env

#Get current branch full name
echo "Obtaining current branch name....."
CURRENT_BRANCH=$(git describe --all)

#Get current branch last commit hash
echo "Getting latest commit hash for branch - $CURRENT_BRANCH....."
CURRENT_BRANCH_HASH=$(git show-ref $CURRENT_BRANCH --hash)

#Build the images for the current branch and hash
IMG_TAG="$CURRENT_BRANCH:$CURRENT_BRANCH_HASH"


#Create the base image for Fetch for current branch and commit hash
DOCKER_IMG_NAME=gcr.io/$GCLOUD_PROJECT_NAME/$APP_NAME/$IMG_TAG
echo "New image identifed: $DOCKER_IMG_NAME"
cd ~/source
echo "Building the new image $DOCKER_IMG_NAME"
docker build --tag=$DOCKER_IMG_NAME .

#Update the gcp container registery
echo "Pushing the image to repo..."
gcloud docker -- push $DOCKER_IMG_NAME

echo "Updating enviornment variables"
echo "DOCKER_IMG_NAME=$DOCKER_IMG_NAME" >> ~/.build_env
