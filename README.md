Very draft environment for building RPMs. Vagrant setups a base system for running `rpmbuild` and uploading with the packages to our Pulp repository.

The `deps/` directory houses Ansible playbooks that install build dependencies for individual modules. You can load them like so:

    bin/prepdeps deps/python27.yml 
