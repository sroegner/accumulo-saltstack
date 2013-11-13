base:
  '*':
    - salt-minion
    - ec2
    - ntp.server
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

  'roles:development':
    - match: grains
    - mvn
