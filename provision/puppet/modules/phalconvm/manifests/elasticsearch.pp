class phalconvm::elasticsearch( $enabled = false ) {
	if $enabled == true {
		class { 'elasticsearch':
			java_install      => true,
			manage_repo       => true,
			repo_version      => '2.x',
			restart_on_change => true,
			api_protocol      => 'http',
			api_host          => 'localhost',
			api_port          => 9200,
		}

		elasticsearch::instance { 'es-01': }
	} else {
	}
}
