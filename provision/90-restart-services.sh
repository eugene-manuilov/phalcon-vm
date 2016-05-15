#!/usr/bin/env bash

# Make sure the services we expect to be running are running.
echo -e "\nRestart services..."
service nginx restart

# Enable PHP modules by default
phpenmod xdebug
phpenmod mcrypt
phpenmod phalcon

service php7.0-fpm restart

# Add the vagrant user to the www-data group so that it has better access to PHP related files.
usermod -a -G www-data vagrant
