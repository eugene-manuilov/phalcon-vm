#!/usr/bin/env bash

npm_install() {
    # npm
    #
    # Make sure we have the latest npm version and the update checker module
    npm install -g npm
    npm install -g npm-check-updates

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
}

xdebug_install() {
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
}

ack_install() {
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
}

composer_install() {
    # COMPOSER
    #
    # Install Composer if it is not yet available.
    if [[ ! -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
        echo "Installing Composer..."
        curl -sS "https://getcomposer.org/installer" | php
        chmod +x "composer.phar"
        mv "composer.phar" "/usr/local/bin/composer"
    fi

    # Update both Composer and any global packages. Updates to Composer are direct from
    # the master branch on its GitHub repository.
    if [[ -n "$(composer --version --no-ansi | grep 'Composer version')" ]]; then
        echo "Updating Composer..."
        COMPOSER_HOME=/usr/local/src/composer composer self-update
        COMPOSER_HOME=/usr/local/src/composer composer -q global config bin-dir /usr/local/bin
        COMPOSER_HOME=/usr/local/src/composer composer -q global require --no-update phalcon/devtools:2.0.11
        COMPOSER_HOME=/usr/local/src/composer composer global update --ignore-platform-reqs
        
        ln -s /usr/local/bin/phalcon.php /usr/bin/phalcon
    fi
}

graphviz_install() {
    # Graphviz
    #
    # Set up a symlink between the Graphviz path defined in the default Webgrind
    # config and actual path.
    echo "Adding graphviz symlink for Webgrind..."
    ln -sf "/usr/bin/dot" "/usr/local/bin/dot"
}

npm_install
xdebug_install
ack_install
composer_install
graphviz_install