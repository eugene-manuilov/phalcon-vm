class phalconvm_phpmyadmin(
	$enabled = false,
	$maxDbList = 100,
	$maxTableList = 250,
	$showSQL = true,
	$allowUserDropDatabase = true,
	$confirm = true,
	$useDbSearch = true,
	$retainQueryBox = false,
	$ignoreMultiSubmitErrors = false,
) {
	if $enabled == true {
		archive { '/tmp/phpmyadmin.tar.gz':
			ensure          => present,
			source          => 'https://github.com/phpmyadmin/phpmyadmin/archive/RELEASE_4_6_4.tar.gz',
			extract         => true,
			extract_path    => '/tmp/',
			creates         => '/srv/www/default/public/phpmyadmin/index.php',
			cleanup         => true,
		}

		->

		exec { 'move-phpmyadmin':
			command => '/bin/mv /tmp/phpmyadmin-RELEASE_4_6_4 /srv/www/default/public/phpmyadmin',
			creates => '/srv/www/default/public/phpmyadmin/index.php',
		}

		->

		file { '/srv/www/default/public/phpmyadmin/config.inc.php':
			ensure  => 'present',
			content => template( '/srv/provision/puppet/templates/phpmyadmin/config.inc.php.erb' ),
		}
	} else {
		file { '/srv/www/default/public/phpmyadmin/':
			ensure => 'absent',
			force  => true,
		}
	}
}
