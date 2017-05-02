# Phalcon VM 2.0.1

[![Flattr this git repo](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=eugene-manuilov&url=https%3A%2F%2Fgithub.com%2Feugene-manuilov%2Fphalcon-vm&title=Phalcon%20VM&language=en_GB&tags=github&category=software)

Phalcon VM is an open source [Vagrant](https://www.vagrantup.com/) configuration which contains wide range of tools required in modern web development. Like a Swiss Army Knife, Phalcon VM allows you to easily activate and use tools required for you project.

The primary goal of this project is to provide an approachable development environment with a modern server configuration for project written with PHP7 and Phalcon 3.x framework. The project also contains compiled [Zephir](http://zephir-lang.com/) executable, which allows you to go even further, beyond just PHP. However it doesn't mean that you have to use only Phalcon framework, you can use it with your framework of choice.

## What will be installed?

After initial provision of your vagrant machine, you will have a fresh Ubuntu 16.04 instance with initial applications set required for very basic development. It includes Nginx server, PHP7 and its extensions (including Phalcon 3.x), Zephir, Composer (with Phalcon Dev Tools installed globally) and a few more. It will also contain a default site which will allow you to configure your environment as you want.

The default site will allow you to activate and configure Varnish cache, MySQL, PostgreSQL or MongoDb databases (along with phpMyAdmin and phpPgAdmin tools), Redis and/or Memcached caching systems (along with phpMemcachedAdmin tool), Gearman and/or RabbitMQ jobs servers, Elasticsearch and/or Sphinxsearch search engines.

Here is full list of what is and can be installed:

1. [Ubuntu](http://www.ubuntu.com/) 16.04 LTS (Xenial Xerus)
1. [nginx](http://nginx.org/) (mainline version)
1. [Varnish](http://varnish-cache.org/) 4.x
1. [Phalcon PHP](https://phalconphp.com/) 3.x
1. [Phalcon Dev Tools](https://docs.phalconphp.com/en/latest/reference/tools.html) 3.x
1. [Zephir](http://zephir-lang.com/) 0.9.x
1. [php-fpm](http://php-fpm.org/) 7.0.x
1. PHP [memcache extension](https://pecl.php.net/package/memcache)
1. PHP [xdebug extension](https://pecl.php.net/package/xdebug/)
1. PHP [imagick extension](https://pecl.php.net/package/imagick/)
1. [PHPUnit](https://phpunit.de/)
1. [MySQL](https://www.mysql.com/)
1. [PostgreSQL](https://www.postgresql.org/)
1. [MongoDB](https://www.mongodb.com/)
1. [Redis](https://redis.io/)
1. [Memcached](http://memcached.org/)
1. [Gearman](http://gearman.org/)
1. [RabbitMQ](https://www.rabbitmq.com/)
1. [Elasticsearch](https://www.elastic.co/)
1. [Sphinxsearch](http://sphinxsearch.com/)
1. [git](http://git-scm.com/)
1. [subversion](https://subversion.apache.org/)
1. [ngrep](http://ngrep.sourceforge.net/usage.html)
1. [dos2unix](http://dos2unix.sourceforge.net/)
1. [Composer](https://github.com/composer/composer)
1. [phpMyAdmin](http://www.phpmyadmin.net/)
1. [phpPgAdmin](https://github.com/phppgadmin/phppgadmin)
1. [phpMemcachedAdmin](https://code.google.com/p/phpmemcacheadmin/)
1. [Opcache Status](https://github.com/rlerdorf/opcache-status)
1. [Webgrind](https://github.com/jokkedk/webgrind)
1. [NodeJs](https://nodejs.org/)
1. [Grunt](http://gruntjs.com/)
1. [Gulp](http://gulpjs.com/)

## Setup Phalcon VM

1. Start with any local operating system such as Mac OS X, Linux, or Windows.
1. Install [VirtualBox 5.0.x](https://www.virtualbox.org/wiki/Downloads).
1. Install [Vagrant 1.8.5+](https://www.vagrantup.com/downloads.html).
    * `vagrant` will now be available as a command in your terminal, try it out.
    * ***Note:*** If Vagrant is already installed, use `vagrant -v` to check the version. You may want to consider upgrading if a much older version is in use.
1. Clone or extract the Phalcon VM project into a local directory.
    * `git clone git@github.com:eugene-manuilov/phalcon-vm.git phalcon-vm`.
    * OR download and extract the repository [zip file](https://github.com/eugene-manuilov/phalcon-vm/archive/master.zip) to a local directory on your computer.
1. In a command prompt, change into the new directory with `cd phalcon-vm`.
1. Start the Vagrant environment with `vagrant up`.
    * Be patient as the magic happens. This could take a while on the first run as your local machine downloads the required files.
    * Watch as the script ends, as an administrator or `su` ***password may be required*** to properly modify the hosts file on your local machine.
1. Visit [the default site](http://phalcon-vm/) in your browser, you should see a dashboard where you can select what tools are needed for your project.

## Create Custom Site

You can easily create a new site in the default dashboard. To do this, go to the [http://phalcon-vm/](http://phalcon-vm/) site and click on `+ Add New Site` link in the sidebar. After doing it you should see a popup which prompts you to enter new site details. So you need to enter required fields like **site name**, **directory** and **domains** to be able to create a new site. After entering that data you need to click on `ADD` button and new site will appear in the sidebar. Finally you need to click `SAVE CHANGES` button in the top right corner to save your changes on disk. After doing it your new site will be created on next provision. So the last step is to stop your current vagrant machine by using `vagrant halt` command and start it again with provisioning flag by using `vagrant up --provision` command.

Please, pay attention to the domains field in the site form. It allows you to enter multiple domains for your site. To do it, just separate your domains with spaces like this: `example.dev test.example.dev jobs.example.dev`. In this case all these domains will be properly added to your local maching hosts file and added to the nginx setup on your vagrant machine.

The new site form is also allows you to create new site using existing repository. Just enter a link to your repository into appropriate field and select proper VCS provider and it will be used to build your site on next provision. **One caveat here**: please, don't forget to copy your private SSH keys to the `ssh/` folder if you want to use SSH connection to your repository.

## Troubleshooting on Windows

### Vagrant gets stucks

If any vagrant command gets stuck on your Windows machine, then you need to check your PowerShell version. Major version needs to be equal or grater than 3. Use `$PSVersionTable.PSVersion` to determine the engine version.

## LICENSE

The MIT License (MIT)
