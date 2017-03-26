class phalconvm::tools::npm {

	package { ['nodejs', 'npm']: 
		ensure => 'installed',
	}

	file { '/usr/bin/node':
		ensure  => 'link',
		target  => '/usr/bin/nodejs',
		require => Package['nodejs'],
	}

	exec { 'bower':
		command => '/usr/bin/npm install -g bower',
		creates => '/usr/local/bin/bower',
		require => Package['npm'],
	}

	exec { 'grunt':
		command => '/usr/bin/npm install -g grunt-cli',
		creates => '/usr/local/bin/grunt',
		require => Package['npm'],
	}

	exec { 'gulp':
		command => '/usr/bin/npm install -g gulp-cli',
		creates => '/usr/local/bin/gulp',
		require => Package['npm'],
	}

	exec { 'webpack':
		command => '/usr/bin/npm install -g webpack',
		creates => '/usr/local/bin/webpack',
		require => Package['npm'],
	}

	exec { 'yarn':
		command => '/usr/bin/npm install -g yarn',
		creates => '/usr/local/bin/yarn',
		require => Package['npm'],
	}

}
