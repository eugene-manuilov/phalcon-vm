class phalconvm::gearman::gearmanui(
	$enabled = false,
) {
	if $enabled == true {
		vcsrepo { 'gearman-ui-repo':
			ensure   => 'present',
			path     => '/srv/www/default/public/gearman-ui',
			provider => 'git',
			source   => 'https://github.com/gaspaio/gearmanui.git',
			revision => '2.0.1',
			depth    => 1,
		}

		exec { 'gearman-ui-composer':
			command     => '/usr/bin/composer install --no-dev',
			cwd         => '/srv/www/default/public/gearman-ui',
			environment => 'COMPOSER_HOME=/usr/local/src/composer',
			refreshonly => true,
			subscribe   => Vcsrepo['gearman-ui-repo'],
		}

		exec { 'gearman-ui-bower':
			command     => '/usr/local/bin/bower install --allow-root',
			cwd         => '/srv/www/default/public/gearman-ui',
			refreshonly => true,
			subscribe   => Vcsrepo['gearman-ui-repo'],
		}

		file { '/srv/www/default/public/gearman-ui/config.yml':
			ensure  => 'present',
			content => template( 'phalconvm/gearman-ui/config.yml.erb' ),
			require => Vcsrepo['gearman-ui-repo'],
		}
	} else {
		file { '/srv/www/default/public/gearman-ui':
			ensure => 'absent',
			force  => true,
		}
	}
}
