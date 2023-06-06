#!/bin/bash

# Cделано в цикле, чтобы избежать ошибки "Could not get lock /var/lib/dpkg/lock-frontend"
# По мотивам https://blog.opstree.com/2022/07/26/how-to-fix-the-dpkg-lock-file-error-in-packer/
while ! [ -x "$(command -v git)" ];
do
    apt install -y git;
    sleep 1;
done;

git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
systemctl enable reddit
