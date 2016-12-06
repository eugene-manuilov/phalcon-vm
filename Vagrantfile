Vagrant.require_version ">= 1.8.5"

required_plugins = %w(vagrant-hostsupdater vagrant-vbguest)
plugins_to_install = required_plugins.select { |plugin| not Vagrant.has_plugin? plugin }
if not plugins_to_install.empty?
	puts "Installing plugins: #{plugins_to_install.join(' ')}"
	if system "vagrant plugin install #{plugins_to_install.join(' ')}"
		exec "vagrant #{ARGV.join(' ')}"
	else
		abort "Installation of one or more plugins has failed. Aborting."
	end
end

require 'json'

class ::Hash
	def deep_merge(second)
		merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
		self.merge(second, &merger)
	end
end

vagrant_dir = File.expand_path(File.dirname(__FILE__))
data_dir = File.join(vagrant_dir, 'www', 'default', 'data')

default_settings = File.join(data_dir, 'defaults.json')
custom_settings = File.join(data_dir, 'settings.json')

settings = JSON.parse(File.read(default_settings))
if File.exists?(custom_settings)
	settings = settings.deep_merge(JSON.parse(File.read(custom_settings)))
end

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/xenial64"
	config.vm.hostname = "phalcon-vm"

	config.ssh.forward_agent = true

	config.vm.network "private_network", ip: "192.168.50.99"
	if settings['varnish']['enabled'] === true
		config.vm.network "forwarded_port", guest: settings['varnish']['port'], host: settings['varnish']['port']
	end
	if settings['mysql']['enabled'] === true and settings['mysql']['forward_port'] === true
		config.vm.network "forwarded_port", guest: settings['mysql']['port'], host: settings['mysql']['port']
	end
	if settings['redis']['enabled'] === true and settings['redis']['forward_port'] === true
		config.vm.network "forwarded_port", guest: settings['redis']['port'], host: settings['redis']['port']
	end
	if settings['memcached']['enabled'] === true and settings['memcached']['forward_port'] === true
		config.vm.network "forwarded_port", guest: settings['memcached']['port'], host: settings['memcached']['port']
	end
	if settings['elasticsearch']['enabled'] === true and settings['elasticsearch']['forward_port'] === true
		config.vm.network "forwarded_port", guest: settings['elasticsearch']['port'], host: settings['elasticsearch']['port']
	end

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
	config.vm.synced_folder "ssh/", "/root/.ssh/", :owner => "root"
	config.vm.synced_folder "log/", "/srv/log/", :owner => "www-data"
	config.vm.synced_folder "www/", "/srv/www/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

	config.vm.synced_folders.each do |id, options|
		# Make sure we use Samba for file mounts on Windows
		if ! options[:type] && Vagrant::Util::Platform.windows?
			options[:type] = "smb"
		end
	end

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
