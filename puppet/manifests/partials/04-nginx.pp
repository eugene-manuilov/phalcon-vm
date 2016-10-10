class phalconvm::nginx {
	file { '/etc/nginx/custom-sites':
		ensure => 'directory',
		owner => 'root',
		group => 'root',
		source => '/srv/config/nginx-config/sites/',
		recurse => true,
		require => Package['nginx'],
		notify => Service['nginx']
	}

	file { '/etc/nginx/nginx.conf':
		source => '/srv/config/nginx-config/nginx.conf',
		owner => 'root',
		group => 'root',
		require => Package['nginx'],
		notify => Service['nginx']
	}

	file { '/etc/nginx/nginx-common.conf':
		source => '/srv/config/nginx-config/nginx-common.conf',
		owner => 'root',
		group => 'root',
		require => Package['nginx'],
		notify => Service['nginx']
	}

	file { '/srv/log/nginx':
		ensure => 'directory',
		owner => 'root',
		group => 'root'
	}

	service { 'nginx':
		ensure => 'running',
		enable => true,
		require => [ Package['nginx'], File['/srv/log/nginx'] ]
	}
}

class { 'phalconvm::nginx': }
