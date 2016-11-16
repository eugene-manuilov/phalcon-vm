class phalconvm ( $settings ) {
	$packages = [
		'imagemagick', 'subversion', 'git', 'zip', 'unzip', 'ngrep', 'curl', 'make',
		'autoconf', 'automake', 'build-essential', 'libxslt1-dev', 're2c',
		'libxml2-dev', 'libmcrypt-dev', 'vim', 'colordiff', 'gcc', 'libpcre3-dev',
		'dos2unix', 'ntp', 'gettext', 'libyaml-dev', 'ack-grep', 'g++',
	]

	# prerequisites
	package { $packages: ensure => 'installed' }

	# php
	class { 'phalconvm::php': * => $settings[php] }
    class { 'phalconvm::php::zephir': }
	class { 'phalconvm::php::phalcon': }
	class { 'phalconvm::php::pecl': }

	# tools
	class { 'phalconvm::tools::composer': }
	class { 'phalconvm::tools::npm': }
	class { 'phalconvm::tools::webgrind': }
	class { 'phalconvm::tools::opcache': }

	# services
	class { 'phalconvm::nginx':                       * => $settings[nginx] }
	class { 'phalconvm::mysql':                       * => $settings[mysql] }
	class { 'phalconvm::mysql::phpmyadmin':           * => $settings[phpMyAdmin] }
	class { 'phalconvm::postgres':                    * => $settings[postgres] }
	class { 'phalconvm::postgres::phppgadmin':        * => $settings[phpPgAdmin] }
	class { 'phalconvm::mongodb':                     * => $settings[mongodb] }
	class { 'phalconvm::redis':                       * => $settings[redis] }
	class { 'phalconvm::memcached':                   * => $settings[memcached] }
	class { 'phalconvm::memcached::phpmemcacheadmin': * => $settings[phpMemcacheAdmin] }
	class { 'phalconvm::gearman':                     * => $settings[gearman] }
	class { 'phalconvm::rabbitmq':                    * => $settings[rabbitmq] }
	class { 'phalconvm::elasticsearch':               * => $settings[elasticsearch] }
	class { 'phalconvm::sphinxsearch':                * => $settings[sphinx] }

	# websites
	class { 'phalconvm::website': sites => $settings[sites] }
}
