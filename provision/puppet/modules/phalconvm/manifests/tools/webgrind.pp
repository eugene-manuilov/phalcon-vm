class phalconvm::tools::webgrind {
	package { 'graphviz': 
		ensure => 'installed',
	}

	vcsrepo { '/srv/www/default/public/webgrind':
		ensure   => 'present',
		provider => 'git',
		source   => 'https://github.com/michaelschiller/webgrind.git',
		depth    => 1,
	}
}
