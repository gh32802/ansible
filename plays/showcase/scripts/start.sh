#!/bin/bash

GET_NODES=1

while getopts ":n" opt; do
  case $opt in
    n)
      GET_NODES=0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $(basename $0) [-v]"
      exit
      ;;
  esac
done

ENVIRONMENT=showcase-test
NODEGROUP=showcase-test-webapp
GETNODES="/wxx/ansible/scripts/get_nodes.pl"
PLAYBOOKDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIMIT=""
RC=0

if (( $# > 0 ))
then
  LIMIT="$@"
else
  LIMIT=''
fi

if (( "$GET_NODES" == 1 ))
then
  $GETNODES $ENVIRONMENT $NODEGROUP
  RC=$?
else
  echo "WSA-Query skipped, using static inventory"
  RC=0
fi

if (( "$RC" == 0 ))
then
  if [ -z "$LIMIT" ]
  then
    ansible-playbook $(dirname $PLAYBOOKDIR)/start.yml
  else
    ansible-playbook $(dirname $PLAYBOOKDIR)/start.yml -l "$LIMIT"
  fi
fi

