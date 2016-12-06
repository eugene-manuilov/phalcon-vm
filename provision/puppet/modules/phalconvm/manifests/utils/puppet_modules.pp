define phalconvm::utils::puppet_modules( $modules ) {
	$modules.each |$module, $version| {
		$command = $version ? {
			false   => "puppet module install ${name}-${module}",
			default => "puppet module install ${name}-${module} --version ${version}",
		}

		exec { "${name}-${module}":
			command => $command,
			creates => "/etc/puppetlabs/code/environments/production/modules/${module}/",
			path    => '/opt/puppetlabs/bin',
		}
	}
}
