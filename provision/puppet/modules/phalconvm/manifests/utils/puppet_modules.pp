define phalconvm::utils::puppet_modules( $modules ) {
	$modules.each |$module, $version| {
		exec { "${name}-${module}":
			command => "/opt/puppetlabs/bin/puppet module install ${name}-${module} --version ${version}",
			creates => "/etc/puppetlabs/code/environments/production/modules/${modules}/",
		}
	}
}
