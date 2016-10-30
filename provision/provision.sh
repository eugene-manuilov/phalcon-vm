#!/bin/bash

# installs puppet and its modules if it is not installed yet
if [ ! -f /opt/puppetlabs/bin/puppet ]; then
	# install latest version of puppet
	pushd /tmp/
	wget http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
	dpkg -i puppetlabs-release-pc1-xenial.deb
	apt-get update --quiet --yes
	apt-get install --quiet --yes puppetserver
	popd

	# make a symlink to puppet executable
	ln -s /opt/puppetlabs/bin/puppet /usr/local/bin/puppet

	# set basemodulepath
	puppet config set basemodulepath "/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules:/srv/provision/puppet/modules" --section main

	# install puppet modules
	puppet module install puppetlabs-stdlib --version 4.13.1
	puppet module install puppetlabs-apt --version 2.3.0
	puppet module install puppetlabs-vcsrepo --version 1.4.0
	puppet module install puppetlabs-inifile --version 1.6.0
	puppet module install puppetlabs-mysql --version 3.9.0
	puppet module install puppetlabs-mongodb --version 0.14.0
	puppet module install computology-packagecloud --version 0.3.1
	puppet module install saz-memcached --version 2.8.1
	puppet module install puppet-nginx --version 0.4.0
	puppet module install puppet-archive --version 1.1.2
	puppet module install elasticsearch-elasticsearch --version 0.14.0
fi

# apply puppet configuration
puppet apply /srv/provision/puppet/setup.pp
