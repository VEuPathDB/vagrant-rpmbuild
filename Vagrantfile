Vagrant.configure(2) do |config|
	config.vm.box = 'puppetlabs/centos-6.6-64-puppet'

  config.ssh.forward_agent = true

  config.vm.hostname = 'package-6-64'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "playbook.yml"
  end

#   config.vm.provision :puppet do |puppet|
#     puppet.options = '--disable_warnings=deprecations'
#     puppet.manifests_path = 'puppet/manifests'
#     puppet.manifest_file = ''
#     puppet.hiera_config_path = 'puppet/hiera.yaml'
#     puppet.module_path = ['puppet/modules', 'puppet/modules/forge', 'puppet/modules/custom', 'puppet/locations', 'puppet/projects']
#   end
end
