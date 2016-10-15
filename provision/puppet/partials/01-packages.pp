$packages = [
	# php packages
	'php7.0', 'php7.0-fpm', 'php7.0-common', 'php7.0-dev', 'php7.0-mbstring',
	'php7.0-mcrypt', 'php7.0-mysql', 'php7.0-imap', 'php7.0-curl', 'php7.0-gd',
	'php7.0-json', 'php-memcache', 'php-imagick', 'php-pear', 'php-xdebug',

	# services
	'mysql-server',

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

package { $packages: ensure => 'installed' }
