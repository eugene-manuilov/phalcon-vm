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
			try_files   => ['$uri', '$uri/', '/index.php?_url=$uri&$args'],
			access_log  => "/srv/log/nginx/${site[directory]}.access.log",
			error_log   => "/srv/log/nginx/${site[directory]}.error.log",
			locations   => {
				"${site[label]}-php-loc" => {
					ensure        => present,
					location      => '~ \.php$',
					try_files     => ['$uri', '=404'],
					fastcgi       => 'phpupstream',
					fastcgi_param => {
						'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name'
					},
				},
			},
		}

		if empty($site[repository]) {
			exec { "${site[label]} Installation":
				command => "phalcon project ${site[directory]} --directory=/tmp && mv /tmp/${site[directory]}/* /srv/www/${site[directory]}/htdocs",
				creates => "/srv/www/${site[directory]}/htdocs/public/index.php",
				path    => '/bin:/usr/bin',
			}
		} else {
			vcsrepo { "/srv/www/${site[directory]}/htdocs":
				ensure   => 'present',
				provider => $site[provider],
				source   => $site[repository],
				require  => [Phalconvm::Utils::Known_host['github.com'], Phalconvm::Utils::Known_host['bitbucket.org']],
			}
		}
	}
}
