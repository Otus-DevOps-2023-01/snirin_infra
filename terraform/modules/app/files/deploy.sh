#!/bin/bash
set -e
APP_DIR=${1:-$HOME}

# Cделано в цикле, чтобы избежать ошибки "Could not get lock /var/lib/dpkg/lock-frontend"
echo "Git install"
until sudo apt-get -y update && sudo apt-get install git -y
do
echo "Try again"
sleep 2
done

git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
