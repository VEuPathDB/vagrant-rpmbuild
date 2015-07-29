Vagrant.configure(2) do |config|
	config.vm.box = 'puppetlabs/centos-6.6-64-puppet'

  config.ssh.forward_agent = true

  config.vm.hostname = 'package-6-64'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.extra_vars = {
      builder_uid: Process.uid,
      builder_gid: Process.gid,
    }
  end

end
