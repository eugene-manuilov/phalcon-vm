# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_dir = File.expand_path(File.dirname(__FILE__))

$setup_puppet = <<SCRIPT
	if ! dpkg -s puppet > /dev/null; then
		sudo apt-get update --quiet --yes
		sudo apt-get install --quiet --yes \
			puppet \
			puppet-module-puppetlabs-apt \
			puppet-module-puppetlabs-mongodb \
			puppet-module-puppetlabs-mysql \
			puppet-module-puppetlabs-postgresql \
			puppet-module-puppetlabs-rabbitmq \
			puppet-module-puppetlabs-vcsrepo

		puppet module install nanliu-staging
		puppet module install example42/puppi
		puppet module upgrade puppetlabs-postgresql
	fi
SCRIPT

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.hostname = "phalcon-vm"
	config.vm.network :private_network, ip: "192.168.50.99"

	config.ssh.forward_agent = true

	config.vm.provider :virtualbox do |v|
		v.memory = 1024
		v.cpus = 2
		v.name = File.basename(Dir.pwd)

		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		v.customize ["modifyvm", :id, "--ioapic", "on"]
		v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
	end

	config.vm.synced_folder "puppet/", "/srv/puppet/"
	config.vm.synced_folder "config/", "/srv/config/"
	config.vm.synced_folder "log/", "/srv/log/", :owner => "www-data"
	config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	if defined?(VagrantPlugins::HostsUpdater)
		paths = Dir[File.join(vagrant_dir, 'www', '**', 'phalcon-hosts')]

		hosts = paths.map do |path|
			lines = File.readlines(path).map(&:chomp)
			lines.grep(/\A[^#]/)
		end.flatten.uniq

		config.hostsupdater.aliases = hosts
		config.hostsupdater.remove_on_suspend = true
	end

	config.vm.provision :shell, :inline => $setup_puppet

	config.vm.provision :puppet do |puppet|
		puppet.module_path = "puppet/modules"
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file  = "init.pp"
		puppet.options = ['--templatedir', '/srv/puppet/files']
	end
end
