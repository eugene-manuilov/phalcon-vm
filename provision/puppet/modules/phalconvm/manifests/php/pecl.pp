class phalconvm::php::pecl {
	package { 'php-pear':
		ensure => 'installed',
	}

	exec { 'pecl-install-yaml':
		command => '/usr/bin/pecl install yaml-2.0.0',
		creates => '/usr/lib/php/20151012/yaml.so',
		require => Package['php-pear'],
	}

	file { '/etc/php/7.0/mods-available/yaml.ini':
		ensure  => 'present',
		owner   => 'root',
		group   => 'root',
		content => 'extension=yaml.so',
		require => Exec['pecl-install-yaml'],
	}

	file { '/etc/php/7.0/fpm/conf.d/20-yaml.ini':
		ensure  => 'link',
		target  => '/etc/php/7.0/mods-available/yaml.ini',
		owner   => 'root',
		group   => 'root',
		require => File['/etc/php/7.0/mods-available/yaml.ini'],
	}
}
