base:
  '*':
    - misc.prereqs
    - sun-java
    - zookeeper
    - hadoop

  'roles:zookeeper':
    - match: grain
    - zookeeper.start

  'roles:datanode':
    - match: grain
    - hadoop.hdfs.datanode

  'roles:namenode':
    - match: grain
    - hadoop.hdfs.namenode
    - hadoop.hdfs.format

