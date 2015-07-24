#!/bin/sh

module_path=/vagrant/puppet/modules/forge
locations_path=/vagrant/puppet/locations
projects_path=/vagrant/puppet/projects
users_path=/vagrant/puppet/manifests/users

mkdir -p "${module_path}"
mkdir -p "${locations_path}"
mkdir -p "${users_path}"

for forge_module in \
                    stahnma-epel \
                    ; do

  module="${forge_module#*-}"
  if [ ! -d "${module_path}/${module}" ]; then
    echo "Installing puppet module ${forge_module}."
    puppet module install --modulepath "${module_path}" "${forge_module}"
  fi

done

for ebrc_module in \
                    rpm_build \
                    ca \
                    maven \
                    pulp \
                    ; do

  if [ ! -d "${module_path}/${ebrc_module}" ]; then
    mkdir "${module_path}/${ebrc_module}"
    git archive --remote=git@git.apidb.org:puppet.git \
        HEAD:modules/${ebrc_module} | tar -x -C "${module_path}/${ebrc_module}"
  fi

done

if [ ! -d "${users_path}" ]; then
  git archive --remote=git@git.apidb.org:puppet.git \
      HEAD:'manifests/users' | tar -x -C "${users_path}"
fi

if [ ! -d "${locations_path}/joint" ]; then
  mkdir -p "${locations_path}/joint"
  git archive --remote=git@git.apidb.org:puppet.git \
      HEAD:locations/joint | tar -x -C "${locations_path}/joint"
fi

if [ ! -d "${projects_path}" ]; then
  mkdir -p "${projects_path}"
  git archive --remote=git@git.apidb.org:puppet.git \
      HEAD:projects | tar -x -C "${projects_path}"
fi
