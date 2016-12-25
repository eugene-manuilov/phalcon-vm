define phalconvm::utils::puppet_modules( $modules ) {
	$modules.each |$module, $version| {
		$command = $version ? {
			false   => "/opt/puppetlabs/bin/puppet module install ${name}-${module}",
			default => "/opt/puppetlabs/bin/puppet module install ${name}-${module} --version ${version}",
		}

		exec { "${name}-${module}":
			command => $command,
			creates => "/etc/puppetlabs/code/environments/production/modules/${module}/",
		}
	}
}
