#!/bin/bash
#
# provision.sh
#
# This file is specified in Vagrantfile and is loaded by Vagrant whenever
# the commands `vagrant up`, `vagrant provision`, or `vagrant reload` are used.

# installs puppet and its modules if it is not installed yet
if ! dpkg -s puppet > /dev/null 2>&1; then
	apt-get update --quiet --yes
	apt-get install --quiet --yes puppet

	puppet module install puppetlabs-stdlib
	puppet module install puppetlabs-apt
	puppet module install puppetlabs-vcsrepo
	puppet module install computology-packagecloud
	puppet module install saz-memcached
fi

# concatinates all puppet scripts into init.pp file
cat /srv/provision/puppet/partials/*.pp > /srv/provision/puppet/init.pp
puppet apply /srv/puppet/manifests/init.pp
