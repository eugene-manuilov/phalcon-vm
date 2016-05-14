# -*- mode: ruby -*-
# vi: set ft=ruby :

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure(2) do |config|
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["modifyvm", :id, "--cpus", 1]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]

#    v.name = File.basename(Dir.pwd)
  end

#  config.ssh.forward_agent = true
  config.vm.box = "ubuntu/xenial64"
#  config.vm.hostname = "phalcon-vm"
  
#  if defined?(VagrantPlugins::HostsUpdater)
#    paths = Dir[File.join(vagrant_dir, 'www', '**', 'phalcon-hosts')]

#    hosts = paths.map do |path|
#      lines = File.readlines(path).map(&:chomp)
#      lines.grep(/\A[^#]/)
#    end.flatten.uniq

#    config.hostsupdater.aliases = hosts
#    config.hostsupdater.remove_on_suspend = true
#  end

#  config.vm.network :private_network, id: "phalcon_vm_primary", ip: "192.168.50.99"
  config.vm.provision :shell, :path => File.join("provision", "provision.sh")
end