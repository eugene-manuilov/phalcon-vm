exec { 'puppetlabs-stdlib':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 4.13.1',
	creates => '/etc/puppetlabs/code/environments/production/modules/stdlib/',
}

exec { 'puppetlabs-apt':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-apt --version 2.3.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/apt/',
}

exec { 'puppetlabs-vcsrepo':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo --version 1.4.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/vcsrepo/',
}

exec { 'puppetlabs-inifile':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-inifile --version 1.6.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/inifile/',
}

exec { 'puppetlabs-mysql':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-mysql --version 3.9.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/mysql/',
}

exec { 'puppetlabs-postgresql':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-postgresql --version 4.8.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/postgresql/',
}

exec { 'puppetlabs-mongodb':
	command => '/opt/puppetlabs/bin/puppet module install puppetlabs-mongodb --version 0.14.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/mongodb/',
}

exec { 'computology-packagecloud':
	command => '/opt/puppetlabs/bin/puppet module install computology-packagecloud --version 0.3.1',
	creates => '/etc/puppetlabs/code/environments/production/modules/packagecloud/',
}

exec { 'saz-memcached':
	command => '/opt/puppetlabs/bin/puppet module install saz-memcached --version 2.8.1',
	creates => '/etc/puppetlabs/code/environments/production/modules/memcached/',
}

exec { 'puppet-nginx':
	command => '/opt/puppetlabs/bin/puppet module install puppet-nginx --version 0.4.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/nginx/',
}

exec { 'puppet-archive':
	command => '/opt/puppetlabs/bin/puppet module install puppet-archive --version 1.1.2',
	creates => '/etc/puppetlabs/code/environments/production/modules/archive/',
}

exec { 'elasticsearch-elasticsearch':
	command => '/opt/puppetlabs/bin/puppet module install elasticsearch-elasticsearch --version 0.14.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/elasticsearch/',
}

exec { 'arioch-redis':
	command => '/opt/puppetlabs/bin/puppet module install arioch-redis --version 1.2.3',
	creates => '/etc/puppetlabs/code/environments/production/modules/redis/',
}

exec { 'maxchk-varnish':
	command => '/opt/puppetlabs/bin/puppet module install maxchk-varnish --version 1.0.0',
	creates => '/etc/puppetlabs/code/environments/production/modules/varnish/',
}
