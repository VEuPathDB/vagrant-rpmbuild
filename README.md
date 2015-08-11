Very draft environment for building RPMs. Vagrant setups a base system for running `rpmbuild` and uploading with the packages to our Pulp repository.

The `deps/` directory houses Ansible playbooks that install build dependencies for individual modules. You can load them like so:

    bin/prepdeps deps/python27.yml


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
