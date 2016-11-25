class phalconvm::postgres(
	$enabled                    = true,
	$password                   = 'postgres',
    $log_min_duration_statement = 250,
) {
	if $enabled == true {
		class { 'postgresql::server':
			postgres_password => $password,
		}

		postgresql::server::config_entry { 'logging_collector':
			ensure => 'present',
			value  => 'on',
		}

		postgresql::server::config_entry { 'log_min_duration_statement':
			ensure => 'present',
			value  => $log_min_duration_statement,
		}

		postgresql::server::config_entry { 'log_statement':
			ensure => 'present',
			value  => 'none',
		}
	} else {
		service { 'postgresql':
			ensure => 'stopped',
		}

		package { ['postgresql-9.5', 'postgresql-client-9.5']:
			ensure  => 'purged',
			require => Service['postgresql'],
		}

		exec { 'postgresql-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['postgresql-9.5'],
		}
	}
}
