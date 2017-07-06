#!/bin/bash
# Deploy script to docker containers server

#Run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 0
fi

# check for existing machine
DOCKER_MACHINE=$(sudo docker-machine ls -q | grep '^vm$')
KEY_PATH=$1

if [ -z "$*" ]; then
  echo "No args: Usage ./deploy.sh <RSA_KEY_PATH>";
  exit 0;
fi

echo "[INFO] Generating react bundle resources for production"
(cd ../ && exec yarn prod)

echo "Start deploying..."
if [ -z "$DOCKER_MACHINE" ]; then
  echo "[INFO] Mapping remote production container in ur env before deploying"
  docker-machine create \
  --driver generic \
  --generic-ip-address=192.168.2.5 \
  --generic-ssh-key $KEYPATH \
  --generic-ssh-user avixy vm
fi

echo "[INFO] Docker machine [vm] is up"
docker-compose -f ../docker-compose-production.yml up --build -d
