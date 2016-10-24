class phalconvm_mysql(
	$enabled = false,
) {
	if $enabled == true {
		package { 'mysql-server':
			ensure => 'present',
		}

		service { 'mysql':
			ensure  => 'running',
			require => Package['mysql-server'],
		}

		$mycnf = {
			'client'     => {
				'user'     => 'root',
				'password' => 'root',
			},
			'mysqladmin' => {
				'user'     => 'root',
				'password' => 'root',
			},
		}

		create_ini_settings( $mycnf, {
			path    => '/home/vagrant/.my.cnf',
			require => Package['mysql-server'],
			notify  => Service['mysql'],
		} )

		$mysqlcnf = {
			'mysqld' => {
				'bind-address'          => '0.0.0.0',
				'max_allowed_packet'    => '128M',
				'innodb_file_per_table' => '1',
			}
		}

		create_ini_settings( $mysqlcnf, {
			path    => '/etc/mysql/mysql.conf.d/mysqld.cnf',
			require => Package['mysql-server'],
			notify  => Service['mysql'],
		} )
	} else {
		service { 'mysql':
			ensure => 'stopped',
		}

		package { 'mysql-server':
			ensure  => 'purged',
			require => Service['mysql'],
		}

		exec { '/usr/bin/apt-get autoremove --purge -y':
			refreshonly => true,
			subscribe   => Package['mysql-server'],
		}
	}
}
