$packages = [
	# php packages
	'php7.0', 'php7.0-fpm', 'php7.0-common', 'php7.0-dev', 'php7.0-mbstring',
	'php7.0-mcrypt', 'php7.0-mysql', 'php7.0-imap', 'php7.0-curl', 'php7.0-gd',
	'php7.0-json', 'php-memcache', 'php-imagick', 'php-pear',

	# services
	'nginx',

	# other packages that come in handy
	'imagemagick', 'subversion', 'git', 'zip', 'unzip', 'ngrep', 'curl', 'make',
	'autoconf', 'automake', 'build-essential', 'libxslt1-dev', 're2c',
	'libxml2-dev', 'libmcrypt-dev', 'vim', 'colordiff', 'gcc', 'libpcre3-dev',
	'dos2unix', 'ntp', 'gettext',

	# nodejs for use by grunt
	'g++', 'nodejs', 'npm',

	# Required for Webgrind
	'graphviz',

	# Mailcatcher requirement
	'libsqlite3-dev'
]

# Install packages from main repository
package { $packages: ensure => 'installed' }

# Configure phalcon's packagecloud repository and install phalcon extension
packagecloud::repo { 'phalcon/stable': type => 'deb' }
package { 'php7.0-phalcon': ensure => 'installed' }

# Configure PHP
file { '/etc/php/7.0/fpm/php-fpm.conf': source => '/srv/config/php-config/php7-fpm.conf', owner => 'root', group => 'root', require => Package['php7.0-fpm'] }
file { '/etc/php/7.0/fpm/pool.d/www.conf': source => '/srv/config/php-config/www.conf', owner => 'root', group => 'root', require => Package['php7.0-fpm'] }
file { '/etc/php/7.0/fpm/conf.d/php-custom.ini': source => '/srv/config/php-config/php-custom.ini', owner => 'root', group => 'root', require => Package['php7.0-fpm'] }
file { '/etc/php/7.0/fpm/conf.d/opcache.ini': source => '/srv/config/php-config/opcache.ini', owner => 'root', group => 'root', require => Package['php7.0-fpm'] }
file { '/srv/config/php-config/phalcon.ini': source => '/etc/php/7.0/mods-available/phalcon.ini', owner => 'root', group => 'root', require => Package['php7.0-phalcon'] }

# Configure Nginx
file { '/etc/nginx/custom-sites': ensure => 'directory', owner => 'root', group => 'root', source => '/srv/config/nginx-config/sites/', recurse => true, require => Package['nginx'], notify => Service['nginx'] }
file { '/etc/nginx/nginx.conf': source => '/srv/config/nginx-config/nginx.conf', owner => 'root', group => 'root', require => Package['nginx'], notify => Service['nginx'] }
file { '/etc/nginx/nginx-common.conf': source => '/srv/config/nginx-config/nginx-common.conf', owner => 'root', group => 'root', require => Package['nginx'], notify => Service['nginx'] }
file { '/srv/log/nginx': ensure => 'directory', owner => 'root', group => 'root' }
service { 'nginx': ensure => 'running', enable => true, require => [ Package['nginx'], File['/srv/log/nginx'] ] }

# Configure Memcache
file { '/srv/log/memcached.log': ensure => 'present', owner => 'root', group => 'root' }
class { 'memcached': listen_ip => '127.0.0.1', max_memory => 128, user => 'memcache', logfile => '/srv/log/memcached.log', require => File['/srv/log/memcached.log'] }
vcsrepo { '/srv/www/default/memcached-admin': ensure => 'present', provider => 'git', source => 'https://github.com/wp-cloud/phpmemcacheadmin.git', revision => '1.2.2.1' }
