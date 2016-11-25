define phalconvm::utils::known_host() {
	exec { "${name}-to-known-hosts":
		command => "ssh-keyscan -H ${name} >> /etc/ssh/ssh_known_hosts",
		onlyif  => "test -z `ssh-keygen -F ${name} -f /etc/ssh/ssh_known_hosts`",
		path    => '/bin:/usr/bin',
	}
}
