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
fi

# install puppet modules and apply server configurations
puppet apply /srv/provision/puppet/modules.pp
puppet apply /srv/provision/puppet/setup.pp
