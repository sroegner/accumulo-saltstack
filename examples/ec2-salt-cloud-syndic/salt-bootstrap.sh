#!/bin/bash
# bootstrap-salt 

exec > /tmp/deploy.out 2>&1
set -x

wget -O - http://bootstrap.saltstack.org | sudo sh -s -- $@

while getopts MS option; do
	case "${option}" in
		M) MASTER=true ;;
		S) SYNDIC=true ;;
	esac
done

echo '/usr/bin/salt-minion -d' >> /etc/rc.local 

if [ -n "$MASTER" ]; then
	echo '/usr/bin/salt-master -d' >> /etc/rc.local 
fi

if [ -n "$SYNDIC" ]; then
	echo '/usr/bin/salt-syndic -d' >> /etc/rc.local 
fi

