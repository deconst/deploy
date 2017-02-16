#!/bin/bash

source ${ROOT}/script/include/credentials.sh

# Bootstrap the localhost inventory to use the current Python intepreter.
setup_inventory() {
  local INSTANCE=$(credential instance)
  local DEPLOYMENT=$(credential deployment)
  local PYTHON=$(which python)
  local DOMAIN=$(credential domain)

  cat <<EOF >${ROOT}/inventory/static
[local]
localhost ansible_python_interpreter=${PYTHON}

# Common group configuration

[deconst-${INSTANCE}-worker-${DEPLOYMENT}:vars]

[deconst-${INSTANCE}-elastic-${DEPLOYMENT}:vars]

[deconst-${INSTANCE}-build-${DEPLOYMENT}:vars]

[deconst-${INSTANCE}-staging-${DEPLOYMENT}:vars]

[deconst-all:children]
deconst-${INSTANCE}-worker-${DEPLOYMENT}
deconst-${INSTANCE}-elastic-${DEPLOYMENT}
deconst-${INSTANCE}-build-${DEPLOYMENT}
deconst-${INSTANCE}-staging-${DEPLOYMENT}

[deconst-all:vars]
ansible_ssh_user=core
ansible_ssh_private_key_file="${ROOT}/keys/${INSTANCE}.private.key"
ansible_python_interpreter="PATH=/home/core/bin:$PATH python"
EOF
}

# Bootstrap roles from Ansible Galaxy if necessary.
setup_galaxy() {
  ([ -f ${ROOT}/.galaxy ] && diff ${ROOT}/.galaxy ${ROOT}/galaxy-requirements.txt >/dev/null 2>&1) || {
    ([ -d /etc/ansible/roles ] && [ -w /etc/ansible/roles ] && [ -x /etc/ansible/roles ]) || {
      cat <<EOM 1>&2
>> /etc/ansible/roles does not exist as a writable directory! You have two options:
>> 1. Run ansible-galaxy manually with sudo.

   sudo ansible-galaxy --force --role-file ${ROOT}/galaxy-requirements.txt
   cp ${ROOT}/galaxy-requirements.txt ${ROOT}/.galaxy

>> 2. Create and chown /etc/ansible/roles.

   sudo mkdir -p /etc/ansible/roles
   sudo chown -R ${USER} /etc/ansible/roles
EOM
      exit 1
    }

    ansible-galaxy install --force --role-file ${ROOT}/galaxy-requirements.txt

    cp ${ROOT}/galaxy-requirements.txt ${ROOT}/.galaxy
    echo ">> Ansible Galaxy roles initialized."
    echo ">> \"rm ${ROOT}/.galaxy\" to force re-initialization."
  }
}
