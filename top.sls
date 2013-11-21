base:
  '*':
    - ec2
    - ntp.server
    - sun-java
    - zookeeper
    - hadoop
    - hadoop.snappy
    - hadoop.hdfs
    - hadoop.mapred
    - accumulo
    - accumulo.server

  'roles:hadoop_master':
    - match: grain
    - zookeeper.server

  'roles:development':
    - match: grain
    - mvn
    - accumulo.development
