file { '/etc/mysql/my.cnf':
	source  => '/srv/config/mysql-config/my.cnf',
	owner   => 'root',
	group   => 'root',
	require => Package['mysql-server'],
	notify  => Service['mysql']
}

file { '/home/vagrant/.my.cnf':
	source  => '/srv/config/mysql-config/root-my.cnf',
	owner   => 'root',
	group   => 'root',
	require => Package['mysql-server'],
	notify  => Service['mysql']
}

file { '/srv/log/mysql':
	ensure => 'directory',
	owner  => 'root',
	group  => 'root'
}

service { 'mysql':
	ensure  => 'running',
	enable  => true,
	require => [ Package['mysql-server'], File['/srv/log/mysql'] ]
}
