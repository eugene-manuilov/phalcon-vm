class phalconvm::rabbitmq( $enabled = false ) {
	if $enabled == true {
		packagecloud::repo { 'rabbitmq/rabbitmq-server': type => 'deb' }

		package { 'rabbitmq-server':
			ensure => 'installed',
			require => Packagecloud::Repo['rabbitmq/rabbitmq-server'],
		}

		service { 'rabbitmq-server':
			ensure  => 'running',
			require => Package['rabbitmq-server'],
		}
	} else {
		service { 'rabbitmq-server':
			ensure => 'stopped',
		}

		package { 'rabbitmq-server':
			ensure  => 'purged',
			require => Service['rabbitmq-server'],
		}

		exec { 'rabbitmq-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['rabbitmq-server'],
		}
	}
}
