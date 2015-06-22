#!/bin/bash

# Bootstrap the localhost inventory to use the current Python intepreter.
setup_inventory() {
  [ -f ${ROOT}/inventory/localhost ] || {
    PYTHON=$(which python)

    cat <<EOF >${ROOT}/inventory/localhost
[local]
localhost ansible_python_interpreter=${PYTHON}
EOF
    echo ">> Ansible localhost inventory bootstrapped to use the current Python interpreter."
  }
}

# Bootstrap roles from Ansible Galaxy if necessary.
setup_galaxy() {
  ([ -f ${ROOT}/.galaxy ] && diff ${ROOT}/.galaxy ${ROOT}/requirements.txt >/dev/null 2>&1) || {
    ([ -d /etc/ansible/roles ] && [ -w /etc/ansible/roles ] && [ -x /etc/ansible/roles ]) || {
      cat <<EOM 1>&2
>> /etc/ansible/roles does not exist as a writable directory! You have two options:
>> 1. Run ansible-galaxy manually with sudo.

   sudo ansible-galaxy --force --role-file ${ROOT}/requirements.txt
   cp ${ROOT}/requirements.txt ${ROOT}/.galaxy

>> 2. Create and chown /etc/ansible/roles.

   sudo mkdir -p /etc/ansible/roles
   sudo chown -R ${USER} /etc/ansible/roles
EOM
      exit 1
    }

    ansible-galaxy install --force --role-file ${ROOT}/requirements.txt

    cp requirements.txt ${ROOT}/.galaxy
    echo ">> Ansible Galaxy roles initialized."
    echo ">> \"rm ${ROOT}/.galaxy\" to force re-initialization."
  }
}
