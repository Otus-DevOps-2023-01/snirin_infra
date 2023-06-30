#!/bin/bash
set -e

#
## Cделано в цикле, чтобы избежать ошибки "Could not get lock /var/lib/dpkg/lock-frontend"
#echo "Iptables install"
#until sudo sudo apt install iptables -y
#do
#echo "Try again"
#sleep 2
#done
#
#
#sudo iptables -A INPUT -p tcp --destination-port 27017 -m state --state NEW,ESTABLISHED -j ACCEPT
#sudo iptables -A OUTPUT -p tcp --source-port 27017 -m state --state ESTABLISHED -j ACCEPT

sudo mv /tmp/mongodb.conf /etc/mongodb.conf
sudo systemctl restart mongodb
