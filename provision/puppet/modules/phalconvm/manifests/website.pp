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

		if empty($site[repository]) {
			exec { "${site[label]} Installation":
				command => "/usr/bin/phalcon project ${site[directory]} --directory=/tmp && /bin/mv /tmp/${site[directory]}/* /srv/www/${site[directory]}/htdocs",
				creates => "/srv/www/${site[directory]}/htdocs/public/index.php",
			}
		} else {
#			vcsrepo { "/srv/www/${site[directory]}/htdocs":
#				ensure   => 'present',
#				provider => $site[provider],
#				source   => $site[repository],
#			}
		}
	}
}
