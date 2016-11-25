class phalconvm::tools::npm {
	package { ['nodejs', 'npm']: 
		ensure => 'installed',
	}

	->

	file { '/usr/bin/node':
		ensure => 'link',
		target => '/usr/bin/nodejs',
	}

	->

	exec { 'bower':
		command => '/usr/bin/npm install -g bower',
		creates => '/usr/local/bin/bower',
	}

	->

	exec { 'grunt':
		command => '/usr/bin/npm install -g grunt-cli',
		creates => '/usr/local/bin/grunt',
	}

	->

	exec { 'gulp':
		command => '/usr/bin/npm install -g gulp-cli',
		creates => '/usr/local/bin/gulp',
	}
}
