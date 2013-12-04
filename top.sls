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
    - hadoop.yarn
    - accumulo
    - accumulo.server
    - accumulo.proxy

  'roles:zookeeper':
    - match: grain
    - zookeeper.server

  'roles:development':
    - match: grain
    - mvn
    - accumulo.development
