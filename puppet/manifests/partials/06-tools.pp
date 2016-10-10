class phalconvm::tools {
	vcsrepo { '/srv/www/default/webgrind':
		ensure => 'present',
		provider => 'git',
		source => 'https://github.com/michaelschiller/webgrind.git'
	}

	vcsrepo { '/srv/www/default/opcache-status':
		ensure => 'present',
		provider => 'git',
		source => 'https://github.com/rlerdorf/opcache-status.git'
	}
}

class { 'phalconvm::tools': }
