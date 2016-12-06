class phalconvm::mysql(
	$enabled                       = false,
	$password                      = 'root',
	$port                          = '3306',
	$forward_port                  = false,
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
					'bind-address'                  => '0.0.0.0',
					'port'                          => $port,
					'general_log'                   => $general_log ? { true => 'on', default => 'off' },
					'slow_query_log'                => $slow_query_log ? { true => 'on', default => 'off' },
					'long_query_time'               => $long_query_time,
					'log_queries_not_using_indexes' => $log_queries_not_using_indexes ? { true => 'on', default => 'off' },
				},
				'client' => {
					'port' => $port,
				},
			}
		}

		mysql_user { 'root@%':
			ensure                   => 'present',
			password_hash            => mysql_password( $password ),
			max_user_connections     => 0,
			max_connections_per_hour => 0,
			max_queries_per_hour     => 0,
			max_updates_per_hour     => 0,
			require                  => Class['::mysql::server'],
		}

		mysql_grant { 'root@%/*.*':
			ensure     => 'present',
			options    => ['GRANT'],
			privileges => ['ALL'],
			table      => '*.*',
			user       => 'root@%',
			require    => Mysql_user['root@%'],
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
