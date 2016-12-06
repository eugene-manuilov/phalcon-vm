class phalconvm::varnish (
	$enabled      = false,
	$port         = '6081',
	$storage_size = '64M',
	$ttl          = '120',
) {
	if $enabled == true {
		class { 'varnish':
			varnish_listen_address => '0.0.0.0',
			varnish_listen_port    => $port,
			varnish_storage_size   => $storage_size,
			varnish_ttl            => $ttl,
			add_repo               => false,
		}

		varnish::backend { 'default':
			host    => '127.0.0.1',
			port    => '80',
			require => Class['varnish'],
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
