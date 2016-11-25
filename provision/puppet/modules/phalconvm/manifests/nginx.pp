class phalconvm::nginx (
	$client_max_body_size = '1024m',
	$client_body_timeout  = '60s',
	$send_timeout         = '60s',
	$keepalive_timeout    = '75s',
	$gzip                 = false,
	$gzip_comp_level      = '5',
	$gzip_min_length      = '256',
	$gzip_disable         = 'msie6',
) {
	$gzip_types = [
		'application/atom+xml', 'pplication/javascript', 'application/json',
		'application/rss+xml', 'application/vnd.ms-fontobject',
		'application/x-font-ttf', 'application/x-javascript',
		'application/x-web-app-manifest+json', 'application/xhtml+xml',
		'application/xml', 'font/opentype', 'image/svg+xml', 'image/x-icon',
		'text/css', 'text/plain', 'text/x-component',
	]

	file { '/srv/log/nginx':
		ensure => 'directory',
	}

	class { '::nginx::config':
		require              => File['/srv/log/nginx'],
		nginx_error_log      => '/srv/log/nginx/error.log',
		sendfile             => 'Off',
		http_tcp_nopush      => 'On',
		keepalive_timeout    => $keepalive_timeout,
		server_tokens        => 'Off',
		client_max_body_size => $client_max_body_size,
		gzip                 => $gzip ? { true => 'on', default => 'off' },
		gzip_comp_level      => $gzip_comp_level,
		gzip_min_length      => $gzip_min_length,
		gzip_disable         => $gzip_disable,
		gzip_types           => $gzip_types,
		http_cfg_append      => {
			'client_body_timeout' => $client_body_timeout,
			'send_timeout'        => $send_timeout,
		},
	}

	class { 'nginx':
		package_ensure => 'present',
		service_ensure => 'running',
	}

	nginx::resource::upstream { 'phpupstream':
		ensure  => present,
		members => ['unix:/run/php/php7.0-fpm.sock'],
	}

	nginx::resource::vhost { "phalcon-vm":
		ensure         => present,
		listen_options => 'default_server',
		www_root       => "/srv/www/default/public",
		index_files    => ['index.php'],
		try_files      => ['$uri', '$uri/', '/index.php?$args'],
		locations      => {
			'~ \.php$'    => {
				ensure        => present,
				try_files     => ['$uri', '=404'],
				fastcgi       => 'phpupstream',
				fastcgi_param => {
					'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name'
				},
			},
			'/php-status' => {
				ensure        => present,
				fastcgi       => 'phpupstream',
				fastcgi_param => {
					'SCRIPT_FILENAME' => '$document_root$fastcgi_script_name'
				},
			}
		},
	}
}
