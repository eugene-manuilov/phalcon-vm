class phalconvm::mysql(
	$enabled                       = false,
	$password                      = 'root',
	$general_log                   = false,
	$slow_query_log                = true,
	$log_queries_not_using_indexes = true,
	$long_query_time               = 1,
) {
	if $enabled == true {
		class { '::mysql::server':
			root_password           => $password,
			remove_default_accounts => true,
			override_options        => {
				'mysqld' => {
					'general_log'                   => $general_log ? {
						true => 'on',
						default => 'off',
					},
					'slow_query_log'                => $slow_query_log ? {
						true => 'on',
						default => 'off',
					},
					'long_query_time'               => $long_query_time,
					'log_queries_not_using_indexes' => $log_queries_not_using_indexes ? {
						true => 'on',
						default => 'off',
					},
				},
			}
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
