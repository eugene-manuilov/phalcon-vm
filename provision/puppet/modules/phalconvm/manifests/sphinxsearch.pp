# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-sphinx-on-ubuntu-14-04

class phalconvm::sphinxsearch( $enabled = false ) {
	if $enabled == true {
		package { 'sphinxsearch': 
			ensure => 'installed',
		}
	} else {
		service { 'sphinxsearch':
			ensure => 'stopped',
		}

		package { 'sphinxsearch':
			ensure  => 'purged',
			require => Service['sphinxsearch'],
		}

		exec { 'sphinxsearch-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['sphinxsearch'],
		}
	}
}
