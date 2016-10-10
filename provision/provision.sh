#!/bin/bash
#
# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant whenever
# the commands `vagrant up`, `vagrant provision`, or `vagrant reload` are used.

# installs puppet and its modules if it is not installed yet
if ! dpkg -s puppet > /dev/null; then
	apt-get update --quiet --yes
	apt-get install --quiet --yes \
		puppet \
		puppet-module-puppetlabs-apt \
		puppet-module-puppetlabs-mysql \
		puppet-module-puppetlabs-postgresql \
		puppet-module-puppetlabs-rabbitmq \
		puppet-module-puppetlabs-vcsrepo

	puppet module install nanliu-staging
	puppet module install computology-packagecloud
	puppet module install saz-memcached
	puppet module upgrade puppetlabs-stdlib
	puppet module upgrade puppetlabs-postgresql
fi

# concatinates all puppet scripts into init.pp file
cat /srv/puppet/manifests/partials/*.pp > /srv/puppet/manifests/init.pp
