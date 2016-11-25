class phalconvm::varnish (
	$enabled      = false,
	$port         = '8080',
	$storage_size = '64M',
) {
	if $enabled == true {
		class { 'varnish':
#			varnish_listen_address => '0.0.0.0',
			varnish_listen_port    => $port,
			varnish_storage_size   => $storage_size,
            add_repo               => false,
		}
	} else {
		service { 'varnish':
			ensure => 'stopped',
		}

		package { 'varnish':
			ensure  => 'purged',
			require => Service['varnish'],
		}

		exec { 'varnish-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['varnish'],
		}
	}
}
