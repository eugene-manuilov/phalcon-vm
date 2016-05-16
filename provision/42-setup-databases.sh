#!/usr/bin/env bash

setup_mysql() {
    # If MySQL is installed, go through the various imports and service tasks.
    local exists_mysql

    exists_mysql="$(service mysql status)"
    if [[ "mysql: unrecognized service" != "${exists_mysql}" ]]; then
        echo -e "\nSetup MySQL configuration file links..."

        # Copy mysql configuration from local
        cp "/srv/config/mysql-config/my.cnf" "/etc/mysql/my.cnf"
        cp "/srv/config/mysql-config/root-my.cnf" "/home/vagrant/.my.cnf"

        echo " * Copied /srv/config/mysql-config/my.cnf to /etc/mysql/my.cnf"
        echo " * Copied /srv/config/mysql-config/root-my.cnf to /home/vagrant/.my.cnf"

        # MySQL gives us an error if we restart a non running service, which
        # happens after a `vagrant halt`. Check to see if it's running before
        # deciding whether to start or restart.
        if [[ "mysql stop/waiting" == "${exists_mysql}" ]]; then
            echo "service mysql start"
            service mysql start
        else
            echo "service mysql restart"
            service mysql restart
        fi
    else
        echo -e "\nMySQL is not installed."
    fi
    
    setup_phpmyadmin
}

setup_phpmyadmin() {
    # Download phpMyAdmin
    if [[ ! -d /srv/www/default/database-admin ]]; then
        echo "Downloading phpMyAdmin..."
        cd /srv/www/default
        wget -q -O phpmyadmin.tar.gz "https://files.phpmyadmin.net/phpMyAdmin/4.6.1/phpMyAdmin-4.6.1-all-languages.zip"
        tar -xf phpmyadmin.tar.gz
        mv phpMyAdmin-4.6.1-all-languages database-admin
        rm phpmyadmin.tar.gz
    else
        echo "PHPMyAdmin already installed."
    fi
    
    cp "/srv/config/phpmyadmin-config/config.inc.php" "/srv/www/default/database-admin/"
}

setup_mysql