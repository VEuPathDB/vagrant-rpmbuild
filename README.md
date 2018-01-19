An environment for building RPMs. Vagrant setups a base system for
running `rpmbuild` and uploading with the packages to our Pulp
repository.

Also includes support for building Singularity images.

## Setup

Clone this repository

    git clone https://github.com/EuPathDB/vagrant-rpmbuild.git

Before vagrant provisioning, copy the `modules/rpm_build/files/gnupg`
directory from our Puppet 3 repo to `ansible/sensitive/gnupg` of this
Vagrant project (these are not in our Puppet 4 repo). These files are
used when signing the rpm files. These files should not be committed to
GitHub (they are excluded in the `.gitignore` file).

These can be yanked directly from git,

    cd vagrant-rpmbuild

    git archive --remote git@git.apidb.org:puppet HEAD | \
      tar --strip-components=3 \
        -C ansible/sensitive/ \
        -x modules/rpm_build/files/gnupg

See `gnupg RPM signing key` in Passpack for passphrase.

This vagrant project supports CentOS 6 and CentOS 7 VMs. Running

    vagrant up

will start and provision both machines. If you want to work with
individual machines, specify `el6` (CentOS 6) or `el7` (CentOS 7) names.

    vagrant up el6

or

    vagrant up el7


The `el6` or `el7` names must be specified when running `vagrant ssh`

    vagrant ssh el6
or

    vagrant ssh el7

Vagrant will provision the guest with a starter RPM build environment.
You will need to install additional software dependencies as needed to
satisfy particular RPM builds. The `vagrant` user has full `sudo` access
to permit any system changes you need.

## The RPM Build Environment

A build directory skeleton is provided on the guest VM at
`~vagrant/rpmbuild`. Note some subdirectories are symlinks to the shared
volume on the host OS so you will be able to access files there if
desired.

    $ ls -gG  ~vagrant/rpmbuild/
    total 0
    drwxrwxr-x 2  6 Jul 13 11:04 BUILD
    drwxrwxr-x 2  6 Jul 13 11:04 BUILDROOT
    lrwxrwxrwx 1 32 Jul 13 11:04 RPMS -> /vagrant/scratch/7/rpmbuild/RPMS
    lrwxrwxrwx 1 35 Jul 13 11:04 SOURCES -> /vagrant/scratch/7/rpmbuild/SOURCES
    lrwxrwxrwx 1 33 Jul 13 11:04 SPECS -> /vagrant/scratch/7/rpmbuild/SPECS
    lrwxrwxrwx 1 33 Jul 13 11:04 SRPMS -> /vagrant/scratch/7/rpmbuild/SRPMS

RPM signing infrastructure is installed as part of the aforementioned
provisioning. See `gnupg RPM signing key` in Passpack for gpg signing
key passphrase.

There is a lot of information online documenting writing spec files and
building RPMs that you should consult.

For EuPathDB specific policies and guidelines see

[Building RPMS](https://wiki.apidb.org/index.php/Building%20RPMs)

[Pulp Yum Repo](https://wiki.apidb.org/index.php/PulpYumRepo)

The `vagrant` account is provisioned with a bash history that contains
some commonly used command examples. This is especially helpful with
seeing example Pulp uses that you can edit for your specific needs. This
might save you a trip to the wiki.

## Shared volumes

For those of us who are not hard-core terminal gurus it can be handy to
have the RPM spec files and source code shared between the VM guest and
host so we have host editors and file browsers available to aid our
work. This Vagrant project delivers and is designed to work around a few
issues with sharing directories between host OS and guest VM that affect
building RPMs.

NFS shared volumes do not have proper ownership on the guest (they
pickup uid/gid from host) and so `rpmbuild` fails with ownership errors
when it tries to unpack source `tar.gz` files. This is an issue with
`rpmbuild` doing specific file owner checks; manually running `tar` on
the source files works fine. Therefore we use VirtualBox's built-in
shared folders (`vboxfs`).

The `vboxfs` VirtualBox sharing is slower than NFS and can be a
problem with very large source code compiles. For most software
packaging though it is not noticeably worse than a native filesystem so
its workable.

A bigger problem with `vboxfs` is that hard links are not allowed on the
shared volume (https://www.virtualbox.org/ticket/818) and some software
requires them. Therefore the `rpmbuild` directory on these VMs is
constructed so the `BUILD` and `BUILDROOT` are on a virtual machine's
native filesystem and the other subdirectories are on the shared volume
for easy access by host editors and so files (especially spec files)
survive a `vagrant destroy`. Soft symbolic links are used to complete
the `rpmbuild` directory structure.

In some cases, running `make install` on a vboxsf shared volume that is
provided by a case-preserving, case-insensitive OS X host volume can
result in the message

    make: `install' is up to date.

because the source code comes with an `INSTALL` file which validates
against make's test for an `install` file. The workaround is to avoid
compiling on shared volumes or, better, make a case-sensitive partition
on your OS X and host your Vagrant project there. This case-sensitive
partition is to store the Vagrant project scratch so it needs to be large
enough to hold RPM sources and related files. This partition does not
store the virtual machine disk images (those are in ~/.vagrant.d) so
around 10 GB for the partition should be plenty for rpm building.


## Experimental

The `deps/` directory houses Ansible playbooks that install build
dependencies for individual modules. You can load them like so:

    bin/prepdeps deps/python27.yml
