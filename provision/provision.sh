#!/bin/bash
#
# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant whenever
# the commands `vagrant up`, `vagrant provision`, or `vagrant reload` are used.
# It checks and installs puppet package and its modules to make sure the main
# provisioning will work smoothly.

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
