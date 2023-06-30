#!/bin/bash

apt update

# Cделано в цикле, чтобы избежать ошибки "Could not get lock /var/lib/dpkg/lock-frontend"
echo "Mongodb install"
until sudo apt install mongodb -y
do
echo "Try again"
sleep 2
done

systemctl enable mongodb
