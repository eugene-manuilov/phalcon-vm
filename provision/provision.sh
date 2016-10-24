#!/bin/bash

# installs puppet and its modules if it is not installed yet
if [ ! -f /opt/puppetlabs/bin/puppet ]; then
	pushd /tmp/
	wget http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
	dpkg -i puppetlabs-release-pc1-xenial.deb
	apt-get update --quiet --yes
	apt-get install --quiet --yes puppetserver
	popd

	/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib
	/opt/puppetlabs/bin/puppet module install puppetlabs-apt
	/opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo
	/opt/puppetlabs/bin/puppet module install puppetlabs-inifile
	/opt/puppetlabs/bin/puppet module install computology-packagecloud
	/opt/puppetlabs/bin/puppet module install saz-memcached
	/opt/puppetlabs/bin/puppet module install puppet-nginx
fi

# concatinates all puppet scripts into init.pp file
cat /srv/provision/puppet/partials/*.pp > /srv/provision/puppet/init.pp
/opt/puppetlabs/bin/puppet apply /srv/provision/puppet/init.pp --noop
