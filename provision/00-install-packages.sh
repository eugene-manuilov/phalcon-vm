#!/usr/bin/env bash

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
    
    # services
    nginx
    memcached
    mysql-server
    
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
    npm

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

    echo "Checking apt-get packages..."
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
    fi
}

package_install