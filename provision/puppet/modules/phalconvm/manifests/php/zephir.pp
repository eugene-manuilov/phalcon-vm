class phalconvm::php::zephir() {
	vcsrepo { '/usr/local/src/zephir':
		ensure   => 'present',
		provider => 'git',
		source   => 'https://github.com/phalcon/zephir.git',
		depth    => 1,
        revision => '0.9.4',
	}

	exec { 'zephir-install':
		command     => '/usr/local/src/zephir/install -c',
        cwd         => '/usr/local/src/zephir/',
        refreshonly => true,
        subscribe   => Vcsrepo['/usr/local/src/zephir'],
    }
}
