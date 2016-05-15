#!/usr/bin/env bash

# PACKAGE INSTALLATION
#
# Build a bash array to pass all of the packages we want to install to a single
# apt-get command. This avoids doing all the leg work each time a package is
# set to install. It also allows us to easily comment out or add single
# packages. We set the array as empty to begin with so that we can append
# individual packages to it as required.
apt_package_install_list=()

# Start with a bash array containing all packages we want to install in the
# virtual machine. We'll then loop through each of these and check individual
# status before adding them to the apt_package_install_list array.
apt_package_check_list=(
    # php packages
    php7.0
    php7.0-fpm
    php7.0-common
    php7.0-dev
    php7.0-mbstring
    php7.0-mcrypt
    php7.0-mysql
    php7.0-imap
    php7.0-curl
    php7.0-gd
    php7.0-json
    php-memcache
    php-imagick
    php-pear
    
    # other packages that come in handy
    imagemagick
    subversion
    git
    zip
    unzip
    ngrep
    curl
    make
    vim
    colordiff
    postfix
    gcc
    re2c
    libpcre3-dev

    # ntp service to keep clock current
    ntp

    # Req'd for i18n tools
    gettext

    # Req'd for Webgrind
    graphviz

    # dos2unix
    # Allows conversion of DOS style line endings to something we'll have less
    # trouble with in Linux.
    dos2unix

    # nodejs for use by grunt
    g++
    nodejs

    #Mailcatcher requirement
    libsqlite3-dev
)

not_installed() {
   if [[ "$(dpkg -s ${1} 2>&1 | grep 'Version:')" ]]; then
      [[ -n "$(apt-cache policy ${1} | grep 'Installed: (none)')" ]] && return 0 || return 1
   else
      return 0
   fi
}

package_check() {
    # Loop through each of our packages that should be installed on the system. If
    # not yet installed, it should be added to the array of packages to install.
    local pkg
    local package_version

    for pkg in "${apt_package_check_list[@]}"; do
        if not_installed "${pkg}"; then
            echo " *" $pkg [not installed]
            apt_package_install_list+=($pkg)
        else
            package_version=$(dpkg -s "${pkg}" 2>&1 | grep 'Version:' | cut -d " " -f 2)
            space_count="$(expr 20 - "${#pkg}")" #11
            pack_space_count="$(expr 30 - "${#package_version}")"
            real_space="$(expr ${space_count} + ${pack_space_count} + ${#package_version})"
            printf " * $pkg %${real_space}.${#package_version}s ${package_version}\n"
        fi
    done   
}

package_install() {
    package_check

    if [[ ${#apt_package_install_list[@]} = 0 ]]; then
        echo -e "No apt packages to install.\n"
    else
        # Update all of the package references before installing anything
        echo "Running apt-get update..."
        apt-get -y update

        # Install required packages
        echo "Installing apt-get packages..."
        apt-get -y install ${apt_package_install_list[@]}

        # Remove unnecessary packages
        echo "Removing unnecessary packages..."
        apt-get autoremove -y

        # Clean up apt caches
        apt-get clean

        # Postfix
        #
        # Use debconf-set-selections to specify the selections in the postfix setup. Set
        # up as an 'Internet Site' with the host name 'vvv'. Note that if your current
        # Internet connection does not allow communication over port 25, you will not be
        # able to send mail, even with postfix installed.
        echo postfix postfix/main_mailer_type select Internet Site | debconf-set-selections
        echo postfix postfix/mailname string vvv | debconf-set-selections

        # Disable ipv6 as some ISPs/mail servers have problems with it
        echo "inet_protocols = ipv4" >> "/etc/postfix/main.cf"
    fi
}

tools_install() {
    # npm
    #
    # Make sure we have the latest npm version and the update checker module
    npm install -g npm
    npm install -g npm-check-updates

    # Xdebug
    #
    # The version of Xdebug 2.4.0 that is available for our Ubuntu installation
    # is not compatible with PHP 7.0. We instead retrieve the source package and
    # go through the manual installation steps.
    if [[ -f /usr/lib/php/20151012/xdebug.so ]]; then
        echo "Xdebug already installed"
    else
        echo "Installing Xdebug"
        # Download and extract Xdebug.
        curl -L -O --silent https://xdebug.org/files/xdebug-2.4.0.tgz
        tar -xf xdebug-2.4.0.tgz
        cd xdebug-2.4.0
        # Create a build environment for Xdebug based on our PHP configuration.
        phpize
        # Complete configuration of the Xdebug build.
        ./configure -q
        # Build the Xdebug module for use with PHP.
        make -s
        # Install the module.
        cp modules/xdebug.so /usr/lib/php/20151012/xdebug.so
        # Clean up.
        cd ..
        rm -rf xdebug-2.4.0*
        echo "Xdebug installed"
    fi

    # ack-grep
    #
    # Install ack-grep directory from the version hosted at beyondgrep.com as the
    # PPAs are not available yet.
    if [[ -f /usr/bin/ack ]]; then
        echo "ack-grep already installed"
    else
        echo "Installing ack-grep as ack"
        curl -s http://beyondgrep.com/ack-2.14-single-file > "/usr/bin/ack" && chmod +x "/usr/bin/ack"
    fi

    # COMPOSER
    #
    # Install Composer if it is not yet available.
    if [[ ! -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
        echo "Installing Composer..."
        curl -sS "https://getcomposer.org/installer" | php
        chmod +x "composer.phar"
        mv "composer.phar" "/usr/local/bin/composer"
    fi

    if [[ -f /vagrant/provision/github.token ]]; then
        ghtoken=`cat /vagrant/provision/github.token`
        composer config --global github-oauth.github.com $ghtoken
        echo "Your personal GitHub token is set for Composer."
    fi

    # Update both Composer and any global packages. Updates to Composer are direct from
    # the master branch on its GitHub repository.
    if [[ -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
        echo "Updating Composer..."
        COMPOSER_HOME=/usr/local/src/composer composer self-update
        COMPOSER_HOME=/usr/local/src/composer composer -q global config bin-dir /usr/local/bin
        COMPOSER_HOME=/usr/local/src/composer composer global update
    fi

    # Grunt
    #
    # Install or Update Grunt based on current state.  Updates are direct
    # from NPM
    if [[ "$(grunt --version)" ]]; then
        echo "Updating Grunt CLI"
        npm update -g grunt-cli &>/dev/null
        npm update -g grunt-sass &>/dev/null
        npm update -g grunt-cssjanus &>/dev/null
        npm update -g grunt-rtlcss &>/dev/null
    else
        echo "Installing Grunt CLI"
        npm install -g grunt-cli &>/dev/null
        npm install -g grunt-sass &>/dev/null
        npm install -g grunt-cssjanus &>/dev/null
        npm install -g grunt-rtlcss &>/dev/null
    fi

    # Graphviz
    #
    # Set up a symlink between the Graphviz path defined in the default Webgrind
    # config and actual path.
    echo "Adding graphviz symlink for Webgrind..."
    ln -sf "/usr/bin/dot" "/usr/local/bin/dot"
}

phalcon_install() {
    # Zephir
    #
    # Build and install zephir if it's not built yet
    if [[ -f /usr/local/bin/zephir ]]; then
        echo "Installing Zephir..."
        git clone https://github.com/phalcon/zephir /tmp/zephir
        cd /tmp/zephir
        ./install -c
    fi

    # PhalconPHP
    #
    # Build and install phalcon extension if it isn't built yet
    if [[ -f /usr/lib/php/20151012/xdebug.so ]]; then
        echo "Installing PhalconPHP..."
        git clone git://github.com/phalcon/cphalcon.git /tmp/cphalcon
        cd /tmp/cphalcon/build
        git checkout origin/2.1.x -b origin/2.1.x
        zephir build —backend=ZendEngine3
    fi
}

php_setup() {
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

    cp "/srv/config/php-config/phalconphp.ini" "/etc/php/7.0/mods-available/phalconphp.ini"
    echo " * Copied /srv/config/php-config/phalconphp.ini to /etc/php/7.0/mods-available/phanlconphp.ini"

    # Find the path to Xdebug and prepend it to xdebug.ini
    XDEBUG_PATH=$( find /usr/lib/php/ -name 'xdebug.so' | head -1 )
    sed -i "1izend_extension=\"$XDEBUG_PATH\"" "/etc/php/7.0/mods-available/xdebug.ini"

    # Find the path to PhalconPHP and prepend it to phalconphp.ini
    PHALCON_PATH=$( find /usr/lib/php/ -name 'phalcon.so' | head -1 )
    sed -i "1izend_extension=\"$PHALCON_PATH\"" "/etc/php/7.0/mods-available/phalconphp.ini"
}

services_restart() {
    # RESTART SERVICES
    #
    # Make sure the services we expect to be running are running.
    echo -e "\nRestart services..."

    # Enable PHP modules by default
    phpenmod xdebug
    phpenmod mcrypt
    phpenmod phalconphp

    service php7.0-fpm restart

    # Add the vagrant user to the www-data group so that it has better access to PHP related files.
    usermod -a -G www-data vagrant
}

package_install
phalcon_install
tools_install
php_setup
services_restart