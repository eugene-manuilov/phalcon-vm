class phalconvm::elasticsearch(
	$enabled      = false,
	$port         = '9200',
	$forward_port = false,
#	$xpack        = false,
) {
	if $enabled == true {
		class { 'elasticsearch':
			manage_repo       => true,
			repo_version      => '2.x',
			restart_on_change => true,
			config            => {
				'http.port' => $port,
			},
		}

		elasticsearch::instance { 'es-01':
			config => {
				'network.bind_host' => '0.0.0.0',
			}
		}

#		if $xpack == true {
#			elasticsearch::plugin { 'elasticsearch/marvel':
#				url       => 'https://download.elastic.co/elasticsearch/release/org/elasticsearch/plugin/marvel-agent/2.4.1/marvel-agent-2.4.1.zip',
#				module_dir => 'marvel',
#				instances => 'es-01',
#			}
#		}
	} else {
		service { 'elasticsearch-es-01':
			ensure => 'stopped',
		}

		package { 'elasticsearch':
			ensure  => 'purged',
			require => Service['elasticsearch-es-01'],
		}

		exec { 'elasticsearch-remove':
			command     => '/usr/bin/apt-get autoremove --purge -y',
			refreshonly => true,
			subscribe   => Package['elasticsearch'],
		}
	}
}
