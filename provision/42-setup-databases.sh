#!/usr/bin/env bash

setup_mysql() {
    # Use debconf-set-selections to specify the default password for the root MySQL
    # account. This runs on every provision, even if MySQL has been installed. If
    # MySQL is already installed, it will not affect anything.
    echo mysql-server mysql-server/root_password password "root" | debconf-set-selections
    echo mysql-server mysql-server/root_password_again password "root" | debconf-set-selections

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
}

setup_mysql