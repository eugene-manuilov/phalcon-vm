class phalconvm::tools::opcache {
	vcsrepo { '/srv/www/default/public/opcache-status':
		ensure   => 'present',
		provider => 'git',
		source   => 'https://github.com/rlerdorf/opcache-status.git',
		depth    => 1,
	}
}
