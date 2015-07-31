WF_SERVERS = {
  :el7 => {
    :vagrant_box     => 'puppetlabs/centos-7.0-64-nocm',
    :wf_hostname     => 'package-7-64',
  },
  :el6 => {
    :vagrant_box     => 'puppetlabs/centos-6.6-64-nocm',
    :wf_hostname     => 'package-6-64',
  }
}

Vagrant.configure(2) do |config|

  config.ssh.forward_agent = true

  WF_SERVERS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.box      = cfg[:vagrant_box] if cfg[:vagrant_box]
      vm_config.vm.hostname = cfg[:wf_hostname] if cfg[:wf_hostname]

      if (name == :el7 and %r{puppetlabs/centos-7}.match(cfg[:vagrant_box]))
        vm_config.vm.provision :shell, path: 'bin/patch_sshd.sh'
      end

      vm_config.vm.provision :ansible do |ansible|
        ansible.playbook = 'playbook.yml'
      end

    end
  end
end
