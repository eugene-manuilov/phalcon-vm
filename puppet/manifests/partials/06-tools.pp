# Webgrind
vcsrepo { '/srv/www/default/webgrind':
	ensure   => 'present',
	provider => 'git',
	source   => 'https://github.com/michaelschiller/webgrind.git',
	depth    => 3,
}

# Opcache Status
vcsrepo { '/srv/www/default/opcache-status':
	ensure   => 'present',
	provider => 'git',
	source   => 'https://github.com/rlerdorf/opcache-status.git',
	depth    => 3,
}

# phpMyAdmin
vcsrepo { '/srv/www/default/database-admin/':
	ensure   => 'present',
	provider => 'git',
	source   => 'https://github.com/phpmyadmin/phpmyadmin.git',
	revision => 'STABLE',
	depth    => 3,
}

file { '/srv/www/default/database-admin/config.inc.php':
	source  => '/srv/config/phpmyadmin-config/config.inc.php',
	require => Vcsrepo['/srv/www/default/database-admin/'],
}
