# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_dir = File.expand_path(File.dirname(__FILE__))

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

	config.vm.provision :shell, :path => File.join( "provision", "provision.sh" )

	config.vm.provision :puppet do |puppet|
		puppet.manifests_path = "puppet/manifests"
		puppet.manifest_file  = "init.pp"
	end
end
