file { '/srv/log/memcached.log':
	ensure => 'present',
	owner  => 'root',
	group  => 'root'
}

class { 'memcached':
	listen_ip  => '127.0.0.1',
	max_memory => 128,
	user       => 'memcache',
	logfile    => '/srv/log/memcached.log',
	require    => File['/srv/log/memcached.log']
}
