#!/usr/bin/env bash

# frontend deploy
#if [ -f /home/ec2-user/build/frontend-dist/index.html ]; then
##  if [ "$(sudo docker inspect -f "{{ .State.Running }}" web)" == "true" ]; then
##  fi
#  sudo cp -r /home/ec2-user/build/frontend-dist/* /usr/share/nginx/html/
#fi

# backend deploy