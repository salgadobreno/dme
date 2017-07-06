#!/bin/bash
# Deploy script to docker containers server
# By: Edson Ma - 06.07.2017

# Run as root
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root"
  exit 0
fi

# Check for existing machine
DOCKER_MACHINE=$(sudo docker-machine ls -q | grep '^vm$')
KEY_FILE=$1

# if no key_file parameter, RTFM
if [ -z "$*" ]; then
  echo "[WARNING] No args: Usage ./deploy.sh <RSA_KEY_FILE>";
  exit 0;
fi

# React Bundle Resources using yarn
echo "[INFO] Generating react bundle resources for production"
(cd ../ && exec yarn prod)

# if remote machine is not here, create one
echo "[INFO] Start deploying..."
if [ -z "$DOCKER_MACHINE" ]; then
  echo "[INFO] Mapping remote production container in ur env before deploying"
  docker-machine create \
  --driver generic \
  --generic-ip-address=192.168.2.5 \
  --generic-ssh-key $KEY_FILE \
  --generic-ssh-user avixy vm
fi

# Deploy application to production container
echo "[INFO] Docker machine [vm] is up"
(cd ../ && exec docker-compose -f docker-compose-production.yml up --build -d)

# Show Machine
echo "[INFO] Docker machine status"
exec sudo docker-machine ls
