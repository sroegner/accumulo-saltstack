base:
  '*':
    - ntp.server
    - misc.prereqs
    - sun-java
    - mvn
    - zookeeper
    - hadoop
    - hadoop.hdfs
    - hadoop.mapred
    - accumulo
    - accumulo.server

  'roles:hadoop_master':
    - match: grains
    - zookeeper.server
