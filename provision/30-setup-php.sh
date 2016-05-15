#!/usr/bin/env bash

echo "Copying configuration files:";

# Copy configurations from local
cp "/srv/config/php-config/php7-fpm.conf" "/etc/php/7.0/fpm/php-fpm.conf"
echo " * Copied /srv/config/php-config/php7-fpm.conf to /etc/php/7.0/fpm/php-fpm.conf"

cp "/srv/config/php-config/www.conf" "/etc/php/7.0/fpm/pool.d/www.conf"
echo " * Copied /srv/config/php-config/www.conf to /etc/php/7.0/fpm/pool.d/www.conf"

cp "/srv/config/php-config/php-custom.ini" "/etc/php/7.0/fpm/conf.d/php-custom.ini"
echo " * Copied /srv/config/php-config/php-custom.ini to /etc/php/7.0/fpm/conf.d/php-custom.ini"

cp "/srv/config/php-config/opcache.ini" "/etc/php/7.0/fpm/conf.d/opcache.ini"
echo " * Copied /srv/config/php-config/opcache.ini to /etc/php/7.0/fpm/conf.d/opcache.ini"

cp "/srv/config/php-config/xdebug.ini" "/etc/php/7.0/mods-available/xdebug.ini"
echo " * Copied /srv/config/php-config/xdebug.ini to /etc/php/7.0/mods-available/xdebug.ini"

cp "/srv/config/php-config/phalcon.ini" "/etc/php/7.0/mods-available/phalcon.ini"
echo " * Copied /srv/config/php-config/phalcon.ini to /etc/php/7.0/mods-available/phanlcon.ini"

# Find the path to Xdebug and prepend it to xdebug.ini
XDEBUG_PATH=$( find /usr/lib/php/ -name 'xdebug.so' | head -1 )
sed -i "1izend_extension=\"$XDEBUG_PATH\"" "/etc/php/7.0/mods-available/xdebug.ini"