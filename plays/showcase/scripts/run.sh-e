#!/bin/bash

ENVIRONMENT=showcase-test
NODEGROUP=showcase-test-webapp
VERBOSE=0

while getopts ":v" opt; do
  case $opt in
    v)
      VERBOSE=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $(basename $0) [-v]"
      exit
      ;;
  esac
done

if (( $VERBOSE == 1 ))
then
  ssh -l webuser -p 2222 localhost build WEBSTAFF/${ENVIRONMENT}/${NODEGROUP} -f -v
else
  ssh -l webuser -p 2222 localhost build WEBSTAFF/${ENVIRONMENT}/${NODEGROUP} -f
fi
