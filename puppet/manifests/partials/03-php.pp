class phalconvm::php {
	file { '/etc/php/7.0/fpm/php-fpm.conf':
		source => '/srv/config/php-config/php7-fpm.conf',
		owner => 'root',
		group => 'root',
		require => Package['php7.0-fpm']
	}

	file { '/etc/php/7.0/fpm/pool.d/www.conf':
		source => '/srv/config/php-config/www.conf',
		owner => 'root',
		group => 'root',
		require => Package['php7.0-fpm']
	}

	file { '/etc/php/7.0/fpm/conf.d/php-custom.ini':
		source => '/srv/config/php-config/php-custom.ini',
		owner => 'root',
		group => 'root',
		require => Package['php7.0-fpm']
	}

	file { '/etc/php/7.0/fpm/conf.d/opcache.ini':
		source => '/srv/config/php-config/opcache.ini',
		owner => 'root',
		group => 'root',
		require => Package['php7.0-fpm']
	}

	file { '/srv/config/php-config/phalcon.ini':
		source => '/etc/php/7.0/mods-available/phalcon.ini',
		owner => 'root',
		group => 'root',
		require => Package['php7.0-phalcon']
	}
}

class { 'phalconvm::php': }
