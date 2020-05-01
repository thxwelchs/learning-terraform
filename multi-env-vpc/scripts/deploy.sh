#!/usr/bin/env bash

function killContainer () {
  local container_name=$1

  if [ "$(sudo docker ps -qa -f name=$container_name)" ]; then
    echo ":: Stopping running container - $container_name"
    sudo docker stop $container_name;

    echo ":: Removing stopped container - $container_name"
    sudo docker rm $container_name;
  fi
}

FRONTEND_IMAGE_REPO_URL=$1
BACKEND_IMAGE_REPO_URL=$2


# ecr login
$(aws ecr get-login --no-include-email --region $AWS_DEFAULT_REGION)

# get repo url
IMAGE_REPO_URL=$(aws ssm get-parameters-by-path --path /dev | jq ' .Parameters | .[] | select(.Name=="/'${ENV_MODE}'/'${DEPLOY_TYPE}'_repo_url") | .Value' --raw-output)

# deploy
if [ $DEPLOY_TYPE != "" ]; then
  sudo docker pull $IMAGE_REPO_URL:latest

  killContainer $DEPLOY_TYPE

  if [ $DEPLOY_TYPE = "backend" ]; then
      sudo docker run -d -p 8080:8080 --name $DEPLOY_TYPE $IMAGE_REPO_URL:latest
  elif [ $DEPLOY_TYPE = "frontend" ]; then
      sudo docker run -d -p 3030:80 --name $DEPLOY_TYPE $IMAGE_REPO_URL:latest
  fi
fi