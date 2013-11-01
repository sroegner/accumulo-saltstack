base:
  '*':
    - ntp.server
    - misc.prereqs
    - sun-java
    - zookeeper
    - hadoop.prereqs
    - hadoop.install

  'roles:zookeeper':
    - match: grain
    - zookeeper.server

  'roles:hadoop_slave':
    - match: grain
    - hadoop.hdfs.datanode
    - hadoop.mapred.tasktracker

  'roles:hadoop_master':
    - match: grain
    - hadoop.hdfs.namenode
    - hadoop.hdfs.secondarynamenode
    - hadoop.hdfs.format
    - hadoop.hdfs.add_tempdir
    - hadoop.mapred.jobtracker
