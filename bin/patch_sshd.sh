# Fix puppetlabs/centos-7.0 boxes misconfigured sshd that prevents
# sftp logins as required by Ansible

conf=/etc/ssh/sshd_config
if grep -q /usr/lib/openssh/sftp-server ${conf}; then
  echo "patching sshd_config"
  sed -i 's;/usr/lib/openssh/sftp-server;/usr/libexec/openssh/sftp-server;' ${conf}
  /bin/systemctl restart sshd.service
fi