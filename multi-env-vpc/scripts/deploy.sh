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

# frontend deploy
if [ $FRONTEND_IMAGE_REPO_URL != "" ]; then
  sudo docker pull $FRONTEND_IMAGE_REPO_URL:latest

  killContainer frontend

  sudo docker run -d -p 3030:80 --name frontend $FRONTEND_IMAGE_REPO_URL:latest
fi

# backend deploy
if [ $BACKEND_IMAGE_REPO_URL != "" ]; then
  sudo docker pull $BACKEND_IMAGE_REPO_URL:latest

  killContainer backend

  sudo docker run -d -p 8080:8080 --name backend $BACKEND_IMAGE_REPO_URL:latest
fi