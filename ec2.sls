/etc/rc.local:
  file.append:
    - text:
      - '# replace the IP'
      - 'IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null)'
      - 'sed -i "s/^.*accumulo-int-03.accumulo-ec2-test.com/${IP} accumulo-int-03.accumulo-ec2-test.com/g" /etc/hosts'
      - 'service hadoop-namenode start'
      - 'service hadoop-secondarynamenode start'
      - 'service hadoop-datanode start'
      - 'service zookeeper start'
      - 'su - accumulo -c "/usr/lib/accumulo/bin/start-all.sh"'

