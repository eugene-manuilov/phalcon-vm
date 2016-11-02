class phalconvm::memcached::phpmemcacheadmin( $enabled = false ) {
	if $enabled == true {
		vcsrepo { '/srv/www/default/public/phpmemcachedadmin':
			ensure   => 'present',
			provider => 'git',
			source   => 'https://github.com/wp-cloud/phpmemcacheadmin.git',
			revision => '1.2.2.1',
			depth    => 1,
		}
	} else {
		file { '/srv/www/default/public/phpmemcachedadmin':
			ensure => 'absent',
			force  => true,
		}
	}
}
