class phalconvm::postgres::phppgadmin( $enabled = true ) {
	if $enabled == true {
		archive { '/tmp/phppgadmin.tar.gz':
			ensure       => 'present',
			source       => 'https://github.com/phppgadmin/phppgadmin/archive/REL_5-1-0.tar.gz',
			extract      => true,
			extract_path => '/tmp/',
			creates      => '/srv/www/default/public/phppgadmin/index.php',
			cleanup      => true,
		}

		exec { 'move-phppgadmin':
			command => '/bin/mv /tmp/phppgadmin-REL_5-1-0 /srv/www/default/public/phppgadmin',
			creates => '/srv/www/default/public/phppgadmin/index.php',
			require => Archive['/tmp/phppgadmin.tar.gz']
		}

		file { '/srv/www/default/public/phppgadmin/conf/config.inc.php':
			ensure  => 'present',
			content => template( 'phalconvm/phppgadmin/config.inc.php.erb' ),
			require => Exec['move-phppgadmin'],
		}
	} else {
		file { '/srv/www/default/public/phppgadmin/':
			ensure => 'absent',
			force  => true,
		}
	}
}
