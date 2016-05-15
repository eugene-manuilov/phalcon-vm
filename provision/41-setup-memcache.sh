#!/usr/bin/env bash


# Copy memcached configuration from local
cp "/srv/config/memcached-config/memcached.conf" "/etc/memcached.conf"
echo " * Copied /srv/config/memcached-config/memcached.conf to /etc/memcached.conf"

# Download and extract phpMemcachedAdmin to provide a dashboard view and
# admin interface to the goings on of memcached when running
if [[ ! -d "/srv/www/default/memcached-admin" ]]; then
    echo -e "\nDownloading phpMemcachedAdmin, see https://github.com/wp-cloud/phpmemcacheadmin"
    cd /srv/www/default
    wget -q -O phpmemcachedadmin.tar.gz "https://github.com/wp-cloud/phpmemcacheadmin/archive/1.2.2.1.tar.gz"
    tar -xf phpmemcachedadmin.tar.gz
    mv phpmemcacheadmin* memcached-admin
    rm phpmemcachedadmin.tar.gz
else
    echo "phpMemcachedAdmin already installed."
fi