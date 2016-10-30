class phalconvm::tools::composer {
	package { 'composer':
		ensure => 'installed',
	}

	->

	exec { 'composer-config':
		command     => '/usr/bin/composer -q global config bin-dir /usr/local/bin',
		environment => 'COMPOSER_HOME=/usr/local/src/composer',
	}

	->

	exec { 'codeception':
		command     => '/usr/bin/composer -q global require codeception/codeception',
		creates     => '/usr/local/src/composer/vendor/codeception/codeception',
		environment => 'COMPOSER_HOME=/usr/local/src/composer',
	}

	->

	exec { 'phpunit':
		command     => '/usr/bin/composer -q global require phpunit/phpunit',
		creates     => '/usr/local/src/composer/vendor/phpunit/phpunit',
		environment => 'COMPOSER_HOME=/usr/local/src/composer',
	}

	->

	exec { 'phalcon-dev-tools':
		command     => '/usr/bin/composer -q global require phalcon/devtools',
		creates     => '/usr/local/src/composer/vendor/phalcon/devtools',
		environment => 'COMPOSER_HOME=/usr/local/src/composer',
	}

	->

	file { '/usr/bin/phalcon':
		ensure  => 'link',
		target  => '/usr/local/bin/phalcon.php',
	}
}
