startup:
  cmd.run:
    - name: {{ pillar['ZOOKEEPER_HOME'] }}/bin/zkServer.sh start
    - user: zookeeper
