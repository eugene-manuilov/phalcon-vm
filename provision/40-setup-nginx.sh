#!/usr/bin/env bash

echo -e "Setup configuration files..."

# Used to ensure proper services are started on `vagrant up`
sudo cp "/srv/config/init/phalconvm-start.conf" "/etc/init/phalconvm-start.conf"
echo " * Copied /srv/config/init/phalconvm-start.conf to /etc/init/phalconvm-start.conf"

# Copy nginx configuration from local
sudo cp "/srv/config/nginx-config/nginx.conf" "/etc/nginx/nginx.conf"
sudo cp "/srv/config/nginx-config/nginx-common.conf" "/etc/nginx/nginx-common.conf"
if [[ ! -d "/etc/nginx/custom-sites" ]]; then
    sudo mkdir "/etc/nginx/custom-sites/"
fi

sudo rsync -rvzh --delete "/srv/config/nginx-config/sites/" "/etc/nginx/custom-sites/"

echo " * Copied /srv/config/nginx-config/nginx.conf to /etc/nginx/nginx.conf"
echo " * Copied /srv/config/nginx-config/nginx-common.conf to /etc/nginx/nginx-common.conf"
echo " * Rsync'd /srv/config/nginx-config/sites/ to /etc/nginx/custom-sites"