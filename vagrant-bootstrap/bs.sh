#!/bin/bash

BS=/vagrant/vagrant-bootstrap
NODE_COUNT=${1:-1}

cp -v ${BS}/hosts /etc/hosts
cp -v ${BS}/minion /etc/salt/minion

#lokkit -p 22:tcp -p 4505:tcp -p 4506:tcp
service iptables stop
chkconfig iptables off

rm -f /etc/salt/minion_id

if [ $NODE_COUNT -gt 0 ]
then
  if [ $(hostname -s) == namenode ]
  then
    cp ${BS}/grains.namenode /etc/salt/grains
  else
    cp ${BS}/grains.datanode /etc/salt/grains
  fi
else
  cp ${BS}/grains.standalone /etc/salt/grains
fi

service salt-minion restart

if [ $(hostname -s) == namenode ]
then
  formulas=$(ls -1 /srv/*-formula 2>/dev/null|wc -l)
  if [ $formulas -gt 0 ]
  then
    cp -v ${BS}/master.localdev /etc/salt/master
  else
    cp -v ${BS}/master /etc/salt/master
  fi
  if [ ! -f /srv/salt/hadoop/files/dsa-hdfs.pub ]
  then
    cd /srv/salt/tools && ./generate_all.sh
  fi
  service salt-master restart
  python ${BS}/refresh-gitfs.py
  echo "===> waiting for minion key requests ..."
  sleep 10
  echo
  salt-key -y -A
  echo "===> just another minute or so ... refreshing gitfs remotes"
  salt \* state.show_lowstate 2>&1 > /dev/null
fi
