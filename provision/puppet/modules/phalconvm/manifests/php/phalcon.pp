class phalconvm::php::phalcon {
	packagecloud::repo { 'phalcon/stable':
		type => 'deb',
	}

	package { 'php7.0-phalcon':
		ensure  => 'installed',
		notify  => Service['php7.0-fpm'],
		require => Packagecloud::Repo['phalcon/stable'],
	}
}
