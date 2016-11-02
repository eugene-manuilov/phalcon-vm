class phalconvm::gearman( $enabled = false ) {
	if $enabled == true {
		package { 'gearman-job-server':
			ensure => 'installed',
		}

		service { 'gearman-job-server':
			ensure  => 'running',
			require => Package['gearman-job-server'],
		}
	} else {
		service { 'gearman-job-server':
			ensure => 'stopped',
		}

		package { 'gearman-job-server': 
			ensure => 'purged',
		}

		exec { 'gearman-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['gearman-job-server'],
		}
	}
}
