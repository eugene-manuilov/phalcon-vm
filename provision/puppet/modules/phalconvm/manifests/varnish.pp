class phalconvm::varnish (
	$enabled      = false,
	$port         = '6081',
	$storage_size = '64M',
	$ttl          = '120',
) {
	if $enabled == true {
		class { 'varnish':
			varnish_vcl_conf       => '/etc/varnish/default.vcl',
			varnish_listen_address => '0.0.0.0',
			varnish_listen_port    => $port,
			varnish_storage_size   => $storage_size,
			varnish_ttl            => $ttl,
			add_repo               => false,
		}

		file { '/etc/varnish/default.vcl':
			ensure  => 'present',
			content => template( 'phalconvm/varnish/default.vcl.erb' ),
			require => Class['varnish'],
		}
	} else {
		service { 'varnish':
			ensure => 'stopped',
		}

		exec { 'varnish-unmount':
			command => 'umount /var/lib/varnish',
			path    => '/bin:/usr/bin',
			unless  => "test -n `mount | grep varnish`",
		}

		package { 'varnish':
			ensure  => 'purged',
			require => [ Service['varnish'], Exec['varnish-unmount'] ],
		}

		exec { 'varnish-remove':
			command     => 'apt-get autoremove --purge -y',
			refreshonly => true,
			path        => '/bin:/usr/bin',
			subscribe   => Package['varnish'],
		}
	}
}
