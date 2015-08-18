Very draft environment for building RPMs. Vagrant setups a base system for running `rpmbuild` and uploading with the packages to our Pulp repository.

## Setup

Before vagrant provisioning, copy the `modules/rpm_build/files/gnupg` directory from our Puppet repo to `sensitive/gnupg` of this Vagrant project. These files are used when signing the rpm files. These files should not be committed to GitHub (they are excluded in the `.gitignore` file).


## 

This vagrant project supports CentOS 6 and CentOS 7 vms. Running

    vagrant up

will start and provision both machines. If you want to work with individual machines, specify `el6` (CentOS 6) or `el7` (CentOS 7) names.

    vagrant up el6

or

    vagrant up el7


The `el6` or `el7` names must be specified when running `vagrant ssh`

    vagrant ssh el6
or

    vagrant ssh el7

## Shared volumes

Problems with sharing directories between host OS and guest VM.

NFS shared volumes do not have proper ownership on guest (they pickup uid/gid
from host) and so `rpmbuild` fails with ownership errors when it tries to unpack
source `tar.gz` files. This is an issue with `rpmbuild` doing specific file owner
checks; manually running `tar` on the source files works fine.

The default `vboxfs` VirtualBox sharing is slower than NFS and can be a problem with
very large source code compiles. In general though it is not much worse than a
native filesystem. The issue with `vboxfs` is that hard links are not allowed
on the shared volume (https://www.virtualbox.org/ticket/818) and some software
requires them. Therefore the `rpmbuild` directory is constructed so the `BUILD`
and `BUILDROOT` are on a native filesystem and the other subdirectories are on
the shared volume for easy access by host editors and so files (especially spec
files) survive a `vagrant destroy`. Symbolic links are used to complete the
`rpmbuild` directory structure.

## Experimental

The `deps/` directory houses Ansible playbooks that install build dependencies for individual modules. You can load them like so:

    bin/prepdeps deps/python27.yml
