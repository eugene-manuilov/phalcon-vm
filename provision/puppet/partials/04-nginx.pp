file { '/srv/log/nginx':
	ensure => 'directory',
}

class { 'nginx':
	nginx_error_log => '/srv/log/nginx/error.log',
	require         => File['/srv/log/nginx'],
}

nginx::resource::upstream { 'phpupstream':
	ensure  => present,
	members => ['unix:/var/run/php7-fpm.sock'],
}

nginx::resource::vhost { "phalcon-vm":
	ensure         => present,
	listen_options => 'default_server',
	www_root       => "/srv/www/default",
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
