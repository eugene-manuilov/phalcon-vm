#!/bin/bash

# installs puppet and its modules if it is not installed yet
if [ ! -f /opt/puppetlabs/bin/puppet ]; then
	pushd /tmp/
	wget http://apt.puppetlabs.com/puppetlabs-release-pc1-xenial.deb
	dpkg -i puppetlabs-release-pc1-xenial.deb
	apt-get update --quiet --yes
	apt-get install --quiet --yes puppetserver
	popd

	/opt/puppetlabs/bin/puppet module install puppetlabs-stdlib --version 4.13.1
	/opt/puppetlabs/bin/puppet module install puppetlabs-apt --version 2.3.0
	/opt/puppetlabs/bin/puppet module install puppetlabs-vcsrepo --version 1.4.0
	/opt/puppetlabs/bin/puppet module install puppetlabs-inifile --version 1.6.0
	/opt/puppetlabs/bin/puppet module install computology-packagecloud --version 0.3.1
	/opt/puppetlabs/bin/puppet module install saz-memcached --version 2.8.1
	/opt/puppetlabs/bin/puppet module install puppet-nginx --version 0.4.0
	/opt/puppetlabs/bin/puppet module install puppet-archive --version 1.1.2
fi

# concatinates all puppet scripts into init.pp file
cat /srv/provision/puppet/partials/*.pp > /srv/provision/puppet/init.pp
/opt/puppetlabs/bin/puppet apply /srv/provision/puppet/init.pp
