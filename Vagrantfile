WF_SERVERS = {
  :el7 => {
    :vagrant_box     => 'ebrc/centos-7-64-puppet',
    :wf_hostname     => 'package-7-64.vm',
  },
  :el6 => {
    :vagrant_box     => 'puppetlabs/centos-6.6-64-nocm',
    :wf_hostname     => 'package-6-64.vm',
  }
}

Vagrant.configure(2) do |config|

  config.ssh.forward_agent = true

  WF_SERVERS.each do |name,cfg|
    config.vm.define name do |vm_config|

      vm_config.vm.provider "virtualbox" do |v|
        v.memory = 2048
        v.cpus = 2
        v.customize ["modifyvm", :id, "--ioapic", "on"]
      end

      vm_config.vm.box      = cfg[:vagrant_box] if cfg[:vagrant_box]
      vm_config.vm.hostname = cfg[:wf_hostname] if cfg[:wf_hostname]

      if Vagrant.has_plugin?('landrush') and not /centos-5/.match(vm_config.vm.box)
       config.landrush.enabled = true
       config.landrush.tld = 'vm'
      end

      # Prepare CentOS 5 to support Ansible
      if ( /centos-5/.match(vm_config.vm.box) )
        vm_config.vm.provision 'Install epel key',
            :type => :shell,
            :inline => 'rpm --import http://mirrors.mit.edu/epel/RPM-GPG-KEY-EPEL'
        vm_config.vm.provision 'Install epel repo',
            :type => :shell,
            :inline => 'rpm -q --quiet epel-release-5-4 || rpm -U http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm'
        vm_config.vm.provision 'Install centos key',
            :type => :shell,
            :inline => 'rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-5'
        vm_config.vm.provision 'Install json',
            :type => :shell,
            :inline => 'yum install -d 0 -e 0 -y python-simplejson'
      end

      if (name == :el7 and %r{puppetlabs/centos-7}.match(cfg[:vagrant_box]))
        vm_config.vm.provision :shell, path: 'bin/patch_sshd.sh'
      end

      vm_config.vm.provision :ansible do |ansible|
        ansible.playbook = 'playbook.yml'
      end

    end
  end
end
