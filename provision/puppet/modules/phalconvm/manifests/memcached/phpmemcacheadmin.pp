class phalconvm::memcached::phpmemcacheadmin( $enabled = false ) {
	vcsrepo { '/srv/www/default/public/phpmemcachedadmin':
		ensure   => $enabled ? {
			true    => 'present',
			false   => 'absent',
			default => 'absent',
		},
		provider => 'git',
		source   => 'https://github.com/wp-cloud/phpmemcacheadmin.git',
		revision => '1.2.2.1',
		depth    => 1,
	}
}
