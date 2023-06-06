#!/bin/bash

apt update

# Cделано в цикле, чтобы избежать ошибки "Could not get lock /var/lib/dpkg/lock-frontend"
# По мотивам https://blog.opstree.com/2022/07/26/how-to-fix-the-dpkg-lock-file-error-in-packer/
while ! [ -x "$(command -v ruby)" ];
do
    apt install -y ruby-full ruby-bundler build-essential;
    sleep 1;
done;
