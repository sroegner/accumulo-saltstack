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
    - hadoop.hdfs.start_datanode

  'roles:namenode':
    - match: grain
    - hadoop.hdfs.namenode
    - hadoop.hdfs.format
    - hadoop.hdfs.start_namenode
