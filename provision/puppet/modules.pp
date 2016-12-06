phalconvm::utils::puppet_modules { 'puppetlabs':
	modules => {
		'stdlib'     => '4.13.1',
		'apt'        => '2.3.0',
		'vcsrepo'    => '1.4.0',
		'inifile'    => '1.6.0',
		'mysql'      => '3.9.0',
		'postgresql' => '4.8.0',
		'mongodb'    => '0.14.0',
	}
}

phalconvm::utils::puppet_modules { 'computology':
	modules => {
		'packagecloud' => '0.3.1',
	}
}

phalconvm::utils::puppet_modules { 'saz':
	modules => {
		'memcached' => '2.8.1',
	}
}

phalconvm::utils::puppet_modules { 'puppet':
	modules => {
		'nginx'   => '0.4.0',
		'archive' => '1.1.2',
	}
}

phalconvm::utils::puppet_modules { 'elasticsearch':
	modules => {
		'elasticsearch' => '0.14.0',
	}
}

phalconvm::utils::puppet_modules { 'arioch':
	modules => {
		'redis' => '1.2.3',
	}
}
