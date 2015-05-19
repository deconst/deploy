#!/bin/bash

# Read a mandatory credential from the credential file.
#
# Arguments:
# - Name of the credential to read from the YAML.
credential() {
  local SETTING=$1
  grep ${SETTING}: ${ROOT}/credentials.yml |
    sed -E -e 's/^[^:]+:[ ]*//' |
    sed -E -e 's/[ ]*$//'
}

[ -f ${ROOT}/credentials.yml ] || {
  cat <<EOM 1>&2
The credentials file is missing! Please set your credentials before continuing.

  cp credentials.example.yml credentials.yml
  \${EDITOR} credentials.yml

EOM
  exit 1
}

# Populate RAX_ environment variables from the credentials file.
export RAX_USERNAME=$(credential rackspace_username)
export RAX_API_KEY=$(credential rackspace_api_key)
export RAX_REGION=$(credential rackspace_region | tr a-z A-Z)
