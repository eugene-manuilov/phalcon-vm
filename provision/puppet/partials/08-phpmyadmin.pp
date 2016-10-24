class phalconvm_phpmyadmin(
	$enabled = false,
	$maxDbList = 100,
	$maxTableList = 250,
	$showSQL = true,
	$allowUserDropDatabase = true,
	$confirm = true,
	$useDbSearch = true,
	$retainQueryBox = false,
	$ignoreMultiSubmitErrors = false,
) {
	vcsrepo { '/srv/www/default/public/phpmyadmin/':
		ensure   => $enabled ? {
			true    => 'present',
			false   => 'absent',
			default => 'absent',
		},
		provider => 'git',
		source   => 'https://github.com/phpmyadmin/phpmyadmin.git',
		revision => 'RELEASE_4_6_4',
		depth    => 1,
	}

#	if $enabled == true {
#    } else {
#    }
}

# file { '/srv/www/default/database-admin/config.inc.php':
# 	source  => '/srv/config/phpmyadmin-config/config.inc.php',
# 	require => Vcsrepo['/srv/www/default/database-admin/'],
# }