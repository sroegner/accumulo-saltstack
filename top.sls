base:
  '*':
    - ntp.server
    - misc.prereqs
    - sun-java
    - zookeeper
    - hadoop
    - hadoop.hdfs
    - hadoop.mapred
    - accumulo
    - accumulo.server

  'roles:hadoop_master':
    - match: grains
    - zookeeper.server
