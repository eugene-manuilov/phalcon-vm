class phalconvm::mongodb( $enabled = false ) {
	if $enabled == true {
		class { '::mongodb::server': }
	} else {
		service { 'mongodb':
			ensure => 'stopped',
		}

		package { 'mongodb-server':
			ensure  => 'purged',
			require => Service['mongodb'],
		}

		exec { 'mongodb-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['mongodb-server'],
		}
	}
}
