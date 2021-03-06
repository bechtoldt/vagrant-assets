#!/bin/bash

echo '##############################################'
echo "Starting ${0}.."
set -x

context_file=/tmp/provisioners_context.sh

if [[ -r $context_file ]]; then
  cat $context_file
  source $context_file

  IFS=','
  bootstrap_params=( $params )
  unset IFS
elif [[ -n "$params" ]]; then
  IFS=','
  bootstrap_params=( $params )
  unset IFS
else
  bootstrap_params=( '-M' '-K' 'stable' )
fi

yum -y install gitpython git

if [[ -z "$(which salt-call)" ]]; then
  wget https://raw.githubusercontent.com/saltstack/salt-bootstrap/stable/bootstrap-salt.sh
  chmod +x bootstrap-salt.sh
  ./bootstrap-salt.sh ${bootstrap_params[@]}
fi

echo "$(hostname -f)" > /etc/salt/minion_id

echo "Finishing ${0}.."
