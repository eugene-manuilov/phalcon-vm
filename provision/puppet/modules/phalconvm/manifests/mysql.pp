class phalconvm::mysql( $enabled = false ) {
	if $enabled == true {
		class { '::mysql::server':
			root_password           => 'root',
			remove_default_accounts => true,
		}
	} else {
		service { 'mysql':
			ensure => 'stopped',
		}

		package { 'mysql-server':
			ensure  => 'purged',
			require => Service['mysql'],
		}

		exec { 'mysql-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['mysql-server'],
		}
	}
}
