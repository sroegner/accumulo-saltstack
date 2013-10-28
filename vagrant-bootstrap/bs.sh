#!/bin/bash

BS=/vagrant/vagrant-bootstrap

cp -v ${BS}/hosts /etc/hosts
cp -v ${BS}/minion /etc/salt/minion

#lokkit -p 22:tcp -p 4505:tcp -p 4506:tcp
service iptables stop
chkconfig iptables off

rm -f /etc/salt/minion_id

if [ $(hostname -s) == namenode ]
then
  cp ${BS}/grains.namenode /etc/salt/grains
else
  cp ${BS}/grains.datanode /etc/salt/grains
fi

service salt-minion restart

if [ $(hostname -s) == namenode ]
then
  echo "===> waiting for minion key requests ..."
  sleep 10
  echo
  salt-key -y -A
  salt-key -L
fi
