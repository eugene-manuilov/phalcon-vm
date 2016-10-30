class phalconvm_sphinx(
	$enabled = false,
) {
	if $enabled == true {
		package { 'sphinxsearch': ensure => 'installed' }
	} else {
		service { 'sphinxsearch':
			ensure => 'stopped',
		}

		->

		package { 'sphinxsearch':
			ensure  => 'purged',
			require => Service['sphinxsearch'],
		}

		->

		exec { 'sphinxsearch-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['sphinxsearch'],
		}
	}
}
