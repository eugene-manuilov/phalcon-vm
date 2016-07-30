# Phalcon VM

Phalcon VM is an open source [Vagrant](https://www.vagrantup.com/) configuration focused on [Phalcon](https://phalconphp.com/) framework development. This configuration has been inspired by [VVV](https://raw.githubusercontent.com/Varying-Vagrant-Vagrants/VVV/) project and has a lot of similarities with it. All contributions are more than welcome.

## About Phalcon VM

The primary goal is to provide an approachable development environment with a modern server configuration for project written with PHP7 and Phalcon 3.x framework. The project also contains compiled [Zephir](http://zephir-lang.com/) executable, which allows you to go even further, beyond just PHP.

## What will be installed?

1. [Ubuntu](http://www.ubuntu.com/) 16.04 LTS (Xenial Xerus)
1. [nginx](http://nginx.org/) (mainline version)
1. [mysql](https://www.mysql.com/) 5.7.x
1. [Phalcon PHP](https://phalconphp.com/) 3.x
1. [Phalcon Dev Tools](https://docs.phalconphp.com/en/latest/reference/tools.html) 3.x
1. [Zephir](http://zephir-lang.com/) 0.9.x
1. [php-fpm](http://php-fpm.org/) 7.0.x
1. [memcached](http://memcached.org/)
1. PHP [memcache extension](https://pecl.php.net/package/memcache)
1. PHP [xdebug extension](https://pecl.php.net/package/xdebug/)
1. PHP [imagick extension](https://pecl.php.net/package/imagick/)
1. [PHPUnit](https://phpunit.de/) 5.3.x
1. [ack-grep](http://beyondgrep.com/)
1. [git](http://git-scm.com/)
1. [subversion](https://subversion.apache.org/)
1. [ngrep](http://ngrep.sourceforge.net/usage.html)
1. [dos2unix](http://dos2unix.sourceforge.net/)
1. [Composer](https://github.com/composer/composer)
1. [phpMemcachedAdmin](https://code.google.com/p/phpmemcacheadmin/)
1. [phpMyAdmin](http://www.phpmyadmin.net/) (multi-language)
1. [Opcache Status](https://github.com/rlerdorf/opcache-status)
1. [Webgrind](https://github.com/jokkedk/webgrind)
1. [NodeJs](https://nodejs.org/)
1. [grunt-cli](https://github.com/gruntjs/grunt-cli)
1. [Mailcatcher](http://mailcatcher.me/)

## Setup Phalcon VM

1. Start with any local operating system such as Mac OS X, Linux, or Windows.
1. Install [VirtualBox 5.0.x](https://www.virtualbox.org/wiki/Downloads)
1. Install [Vagrant 1.8.x](https://www.vagrantup.com/downloads.html)
    * `vagrant` will now be available as a command in your terminal, try it out.
    * ***Note:*** If Vagrant is already installed, use `vagrant -v` to check the version. You may want to consider upgrading if a much older version is in use.
1. Install the [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) plugin with `vagrant plugin install vagrant-hostsupdater`
    * Note: This step is not a requirement, though it does make the process of starting up a virtual machine nicer by automating the entries needed in your local machine's `hosts` file to access the provisioned domains in your browser.
    * If you choose not to install this plugin, a manual entry should be added to your local `hosts` file that looks like this: `192.168.50.99  phalcon-vm phalcon.dev`
1. Clone or extract the Phalcon VM project into a local directory
    * `git clone git@github.com:eugene-manuilov/phalcon-vm.git phalcon-vm`
    * OR download and extract the repository [zip file](https://github.com/eugene-manuilov/phalcon-vm/archive/master.zip) to a local directory on your computer.
1. In a command prompt, change into the new directory with `cd phalcon-vm`
1. Start the Vagrant environment with `vagrant up`
    * Be patient as the magic happens. This could take a while on the first run as your local machine downloads the required files.
    * Watch as the script ends, as an administrator or `su` ***password may be required*** to properly modify the hosts file on your local machine.
1. Visit any of the following default sites in your browser:
    * [http://phalcon.dev/](http://phalcon.dev/) for Phalcon site
    * [http://phalcon-vm/](http://phalcon-vm/) for a default dashboard containing several useful tools

## LICENSE

The MIT License (MIT)