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

		nginx::resource::vhost { 'gearman-ui-host':
			ensure      => 'present',
			server_name => ['gearman-ui'],
			www_root    => "/srv/www/default/public/gearman-ui/web/",
			index_files => ['index.php'],
			try_files   => ['$uri', '$uri/', '/index.php?$args'],
			access_log  => "/srv/log/nginx/gearman-ui.access.log",
			error_log   => "/srv/log/nginx/gearman-ui.error.log",
			require     => Vcsrepo['gearman-ui-repo'],
			locations   => {
				"gearman-ui-php-loc" => {
					ensure        => 'present',
					location      => '~ \.php$',
					try_files     => ['$uri', '=404'],
					fastcgi       => 'phpupstream',
					fastcgi_param => {
						'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name'
					},
				},
			},
		}
	} else {
		file { '/srv/www/default/public/gearman-ui':
			ensure => 'absent',
			force  => true,
		}

		nginx::resource::vhost { 'gearman-ui-host':
			ensure      => 'absent',
			server_name => ['gearman-ui'],
			www_root    => "/srv/www/default/public/gearman-ui/web/",
		}
	}
}
