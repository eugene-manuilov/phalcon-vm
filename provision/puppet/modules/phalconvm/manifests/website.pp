class phalconvm::website( $sites = [] ) {
	$sites.each |$site| {
		file {"/srv/www/${site[directory]}/htdocs":
			ensure => 'directory',
            owner  => 'www-data',
            group  => 'www-data',
		}
    }
}
