class phalconvm::php(
	$max_execution_time              = '30',
	$memory_limit                    = '128M',
	$post_max_size                   = '1024M',
	$upload_max_filesize             = '1024M',
	$max_file_uploads                = '20',
	$display_errors                  = true,
	$display_startup_errors          = true,
	$log_errors                      = true,
	$ignore_repeated_errors          = false,
	$ignore_repeated_source          = false,
	$track_errors                    = false,
	$html_errors                     = true,
	$xdebug_idekey                   = 'PVMDBG',
	$xdebug_var_display_max_children = '-1',
	$xdebug_var_display_max_data     = '-1',
	$xdebug_var_display_max_depth    = '-1',
) {
	$packages = [
		'php7.0', 'php7.0-fpm', 'php7.0-common', 'php7.0-dev', 'php7.0-mbstring',
		'php7.0-mcrypt', 'php7.0-mysql', 'php7.0-imap', 'php7.0-curl', 'php7.0-gd',
		'php7.0-json', 'php-memcache', 'php-imagick', 'php-xdebug', 'php7.0-pgsql',
	]

	package { $packages: ensure => 'installed' }

	$poold_www = {
		'www' => {
			'listen.mode'          => '0666',
			'pm.max_requests'      => 100,
			'pm.status_path'       => '/php-status',
			'chdir'                => '/',
			'catch_workers_output' => 'yes',
		}
	}

	create_ini_settings( $poold_www, {
		path    => '/etc/php/7.0/fpm/pool.d/www.conf',
		require => Package['php7.0-fpm'],
		notify  => Service['php7.0-fpm'],
	} )

	$php = {
		'PHP' => {
			'short_open_tag'                 => 'Off',
			'allow_call_time_pass_reference' => 'Off',
			'max_execution_time'             => $max_execution_time,
			'memory_limit'                   => $memory_limit,
			'error_reporting'                => 'E_ALL | E_STRICT',
			'display_errors'                 => $display_errors         ? { true => 'On', default => 'Off' },
			'display_startup_errors'         => $display_startup_errors ? { true => 'On', default => 'Off' },
			'log_errors'                     => $log_errors             ? { true => 'On', default => 'Off' },
			'log_errors_max_len'             => '1024',
			'ignore_repeated_errors'         => $ignore_repeated_errors ? { true => 'On', default => 'Off' },
			'ignore_repeated_source'         => $ignore_repeated_source ? { true => 'On', default => 'Off' },
			'track_errors'                   => $track_errors           ? { true => 'On', default => 'Off' },
			'html_errors'                    => $html_errors            ? { true => 'On', default => 'Off' },
			'error_log'                      => '/srv/log/php_errors.log',
			'post_max_size'                  => $post_max_size,
			'upload_max_filesize'            => $upload_max_filesize,
			'max_file_uploads'               => $max_file_uploads,
			'default_socket_timeout'         => 60,
		}
	}

	create_ini_settings( $php, {
		path    => '/etc/php/7.0/fpm/php.ini',
		require => Package['php7.0-fpm'],
		notify  => Service['php7.0-fpm'],
	} )

	file { '/srv/log/xdebug-remote.log':
		ensure => 'present',
		owner  => 'www-data',
		group  => 'www-data',
	}

	$xdebug = {
		'XDebug' => {
			'xdebug.collect_params'           => 1,
			'xdebug.idekey'                   => $xdebug_idekey,
			'xdebug.profiler_enable_trigger'  => 1,
			'xdebug.profiler_output_name'     => 'cachegrind.out.%t-%s',
			'xdebug.remote_enable'            => 1,
			'xdebug.remote_host'              => '192.168.50.99',
			'xdebug.remote_log'               => '/srv/log/xdebug-remote.log',
			'xdebug.var_display_max_children' => $xdebug_var_display_max_children,
			'xdebug.var_display_max_data'     => $xdebug_var_display_max_data,
			'xdebug.var_display_max_depth'    => $xdebug_var_display_max_depth,
		}
	}

	create_ini_settings( $xdebug, {
		path    => '/etc/php/7.0/mods-available/xdebug.ini',
		require => [ Package['php-xdebug'], File['/srv/log/xdebug-remote.log'] ],
		notify  => Service['php7.0-fpm'],
	} )

	$opcache = {
		'opcache' => {
			'opcache.enable'             => 1,
			'opcache.memory_consumption' => 128,
		}
	}

	create_ini_settings( $opcache, {
		path    => '/etc/php/7.0/mods-available/opcache.ini',
		require => Package['php7.0'],
		notify  => Service['php7.0-fpm'],
	} )

	service { 'php7.0-fpm':
		ensure => 'running',
	}
}
