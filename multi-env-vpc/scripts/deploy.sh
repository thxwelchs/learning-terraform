#!/usr/bin/env bash

function killContainer () {
  if [ "$(sudo docker ps -qa -f name=$1)" ]; then
    echo ":: Stopping running container - $1"
    sudo docker stop $1;

    echo ":: Removing stopped container - $1"
    sudo docker rm $1;
  fi
}

BACKEND_IMAGE_REPO_URL=""
FRONTEND_IMAGE_REPO_URL=""

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

  killContainer frontend

  sudo docker run -d -p 8080:8080 --name backend $BACKEND_IMAGE_REPO_URL:latest
fi