#!/bin/bash

if [ $# -ne 2 ]; then
    echo There shoud be 2 parameters passed: instance name, image id.
    exit 1
fi

yc compute instance create \
  --name $1 \
  --hostname $1 \
  --memory=4 \
  --create-boot-disk image-id=$2,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --ssh-key ~/.ssh/appuser.pub
