class phalconvm::website( $sites = [] ) {
	$sites.each |$site| {
		file { "/srv/www/${site[directory]}":
			ensure => 'directory',
		}

		file { "/srv/www/${site[directory]}/htdocs":
			ensure  => 'directory',
            require => File["/srv/www/${site[directory]}"],
		}

		nginx::resource::vhost { $site[label]:
			ensure      => present,
			server_name => split($site[domains], ' '),
			www_root    => "/srv/www/${site[directory]}/htdocs/public",
			index_files => ['index.php'],
			try_files   => ['$uri', '$uri/', '/index.php?$args'],
			locations   => {
				"${site[label]}-php-loc" => {
					ensure        => present,
					location      => '~ \.php$',
					try_files     => ['$uri', '=404'],
					fastcgi       => 'phpupstream',
					fastcgi_param => {
						'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name'
					},
				}
			},
		}
	}
}
