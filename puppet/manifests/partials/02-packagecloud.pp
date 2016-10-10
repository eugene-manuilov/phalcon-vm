class phalconvm::packagecloud {
	packagecloud::repo { 'phalcon/stable':
		type => 'deb'
	}

	package { 'php7.0-phalcon':
		ensure => 'installed'
	}
}

class { 'phalconvm::packagecloud': }
