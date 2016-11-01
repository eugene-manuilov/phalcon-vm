class phalconvm::redis( $enabled = false ) {
	if $enabled == true {
		class { 'redis':
		}
	} else {
		service { 'redis-server': ensure => 'stopped' }

		->

		package { 'redis-server': ensure  => 'purged' }

		->

		exec { 'redis-remove': command => '/usr/bin/apt-get autoremove --purge -y' }
	}
}
