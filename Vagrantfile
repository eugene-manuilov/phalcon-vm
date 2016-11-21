# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

vagrant_dir = File.expand_path(File.dirname(__FILE__))
data_dir = File.join(vagrant_dir, 'www', 'default', 'data')

default_settings = File.join(data_dir, 'defaults.json')
custom_settings = File.join(data_dir, 'settings.json')

settings = JSON.parse(File.read(default_settings))
if File.exists?(custom_settings)
	settings = settings.merge(JSON.parse(File.read(custom_settings)))
end

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.hostname = "phalcon-vm"

	config.ssh.forward_agent = true

	config.vm.network "private_network", ip: "192.168.50.99"
	config.vm.network "forwarded_port", guest: settings['redis']['port'], host: settings['redis']['port']
	config.vm.network "forwarded_port", guest: settings['memcached']['tcp_port'], host: settings['memcached']['tcp_port']
	config.vm.network "forwarded_port", guest: settings['elasticsearch']['port'], host: settings['elasticsearch']['port']

	config.vm.provider :virtualbox do |v|
		v.memory = 1024
		v.cpus = 2
		v.name = File.basename(Dir.pwd)

		v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
		v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
		v.customize ["modifyvm", :id, "--ioapic", "on"]
		v.customize ["modifyvm", :id, "--nictype1", "Am79C973"]
	end

	config.vm.synced_folder "provision/", "/srv/provision/"
	config.vm.synced_folder "log/", "/srv/log/", :owner => "www-data"
	config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	if defined?(VagrantPlugins::HostsUpdater)
		hosts = settings['sites'].map do |site|
			site['domains']
		end

		config.hostsupdater.aliases = hosts
		config.hostsupdater.remove_on_suspend = true
	end

	config.vm.provision "fix-no-tty", type: "shell" do |s|
		s.privileged = false
		s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
	end

	config.vm.provision "provision", type: "shell", path: File.join( "provision", "provision.sh" )
	config.vm.provision "startup",   type: "shell", path: File.join( "provision", "startup.sh" ), run: "always"
end
