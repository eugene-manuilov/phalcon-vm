class phalconvm::mysql::phpmyadmin(
	$enabled = false,
	$maxDbList = 100,
	$maxTableList = 250,
	$showSQL = true,
	$allowUserDropDatabase = true,
	$confirm = true,
	$useDbSearch = true,
	$retainQueryBox = false,
	$ignoreMultiSubmitErrors = false,
	$port = 3306,
) {
	if $enabled == true {
		archive { '/tmp/phpmyadmin.tar.gz':
			ensure       => 'present',
			source       => 'https://github.com/phpmyadmin/phpmyadmin/archive/RELEASE_4_6_4.tar.gz',
			extract      => true,
			extract_path => '/tmp/',
			creates      => '/srv/www/default/public/phpmyadmin/index.php',
			cleanup      => true,
		}

		exec { 'move-phpmyadmin':
			command => '/bin/mv /tmp/phpmyadmin-RELEASE_4_6_4 /srv/www/default/public/phpmyadmin',
			creates => '/srv/www/default/public/phpmyadmin/index.php',
			require => Archive['/tmp/phpmyadmin.tar.gz']
		}

		$fqdn_rand = fqdn_rand( 9999 )
		$blowfish_secret = pw_hash( "${fqdn_rand}", 'SHA-512', 'JXXdi4G0Nl9xlh0emuoHZNSuPvZ0qcfGx1hF4cUfOkf3jS' )

		file { '/srv/www/default/public/phpmyadmin/config.inc.php':
			ensure  => 'present',
			content => template( 'phalconvm/phpmyadmin/config.inc.php.erb' ),
			require => Exec['move-phpmyadmin'],
		}
	} else {
		file { '/srv/www/default/public/phpmyadmin/':
			ensure => 'absent',
			force  => true,
		}
	}
}
