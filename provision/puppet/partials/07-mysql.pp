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

		file { '/srv/log/mysql':
			ensure => 'directory',
			owner  => 'root',
			group  => 'root',
		}
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

		file { '/srv/log/mysql':
			ensure => 'absent',
			owner  => 'root',
			group  => 'root',
		}
	}
}

#file { '/etc/mysql/my.cnf':
#	source  => '/srv/config/mysql-config/my.cnf',
#	owner   => 'root',
#	group   => 'root',
#	require => Package['mysql-server'],
#	notify  => Service['mysql']
#}
#
#file { '/home/vagrant/.my.cnf':
#	source  => '/srv/config/mysql-config/root-my.cnf',
#	owner   => 'root',
#	group   => 'root',
#	require => Package['mysql-server'],
#	notify  => Service['mysql']
#}
#
#service { 'mysql':
#	ensure  => 'running',
#	enable  => true,
#	require => [ Package['mysql-server'], File['/srv/log/mysql'] ]
#}
#
# # phpMyAdmin
# vcsrepo { '/srv/www/default/database-admin/':
# 	ensure   => 'present',
# 	provider => 'git',
# 	source   => 'https://github.com/phpmyadmin/phpmyadmin.git',
# 	revision => 'RELEASE_4_6_4',
# 	depth    => 3,
# }
#
# file { '/srv/www/default/database-admin/config.inc.php':
# 	source  => '/srv/config/phpmyadmin-config/config.inc.php',
# 	require => Vcsrepo['/srv/www/default/database-admin/'],
# }
