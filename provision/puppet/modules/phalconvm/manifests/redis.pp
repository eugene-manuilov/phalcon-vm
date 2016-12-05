class phalconvm::redis(
	$enabled                 = false,
	$port                    = 6379,
	$forward_port            = false,
	$maxmemory               = 64,
	$save_db_to_disk         = true,
	$slowlog_log_slower_than = 100,
) {
	if $enabled == true {
		class { 'redis':
			port                    => $port,
			maxmemory               => $maxmemory << 20,
			maxmemory_policy        => 'volatile-lru',
			save_db_to_disk         => $save_db_to_disk,
			daemonize               => true,
			slowlog_log_slower_than => $slowlog_log_slower_than * 1000,
		}
	} else {
		service { 'redis-server':
			ensure => 'stopped',
		}

		package { 'redis-server':
			ensure  => 'purged',
			require => Service['redis-server'],
		}

		exec { 'redis-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['redis-server'],
		}
	}
}
