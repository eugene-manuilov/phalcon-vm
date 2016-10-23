# Webgrind
vcsrepo { '/srv/www/default/public/webgrind':
	ensure   => 'present',
	provider => 'git',
	source   => 'https://github.com/michaelschiller/webgrind.git',
	depth    => 1,
}

# Opcache Status
vcsrepo { '/srv/www/default/public/opcache-status':
	ensure   => 'present',
	provider => 'git',
	source   => 'https://github.com/rlerdorf/opcache-status.git',
	depth    => 1,
}

# Bower
exec { 'bower-install':
	command => '/usr/bin/npm install -g bower',
	creates => '/usr/local/bin/bower',
    require => Package['npm'],
}

file { '/usr/bin/node':
	ensure  => 'link',
	target  => '/usr/bin/nodejs',
	require => Package['nodejs'],
}

# Composer

exec { 'composer-config':
	command     => '/usr/bin/composer -q global config bin-dir /usr/local/bin',
	environment => 'COMPOSER_HOME=/usr/local/src/composer',
	require     => Package['composer'],
}

$composer_dependency = [ Package['composer'], Exec['composer-config'] ]

exec { 'composer-phalcon-dev-tools':
	command     => '/usr/bin/composer -q global require phalcon/devtools',
	creates     => '/usr/local/src/composer/vendor/phalcon/devtools',
	environment => 'COMPOSER_HOME=/usr/local/src/composer',
	require     => $composer_dependency,
}

exec { 'composer-codeception':
	command     => '/usr/bin/composer -q global require codeception/codeception',
	creates     => '/usr/local/src/composer/vendor/codeception/codeception',
	environment => 'COMPOSER_HOME=/usr/local/src/composer',
	require     => $composer_dependency,
}

exec { 'composer-phpunit':
	command     => '/usr/bin/composer -q global require phpunit/phpunit',
	creates     => '/usr/local/src/composer/vendor/phpunit/phpunit',
	environment => 'COMPOSER_HOME=/usr/local/src/composer',
	require     => $composer_dependency,
}

file { '/usr/bin/phalcon':
	ensure  => 'link',
	target  => '/usr/local/bin/phalcon.php',
	require => Exec['composer-phalcon-dev-tools'],
}