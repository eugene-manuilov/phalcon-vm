class phalconvm::tools::npm {

	class { 'nodejs':
		version    => 'lts',
		target_dir => '/usr/local/bin',
	}

	package { ['bower', 'grunt', 'gulp', 'webpack', 'yarn']:
		ensure   => 'present',
		provider => 'npm',
		require  => Class['nodejs'],
	}

	file { '/etc/profile.d/append-npm-bin-path.sh':
		mode    => '644',
		content => 'PATH=$PATH:/usr/local/node/node-default/bin',
		require => Class['nodejs'],
	}
    
}
