base:
  '*':
    - epel
    - ntp.server
    - misc.prereqs
    - sun-java
    - zookeeper
    - hadoop

  'roles:zookeeper':
    - match: grain
    - zookeeper.server

  'roles:datanode':
    - match: grain
    - hadoop.hdfs.datanode
    - hadoop.hdfs.start_datanode

  'roles:namenode':
    - match: grain
    - hadoop.hdfs.namenode
    - hadoop.hdfs.format
    - hadoop.hdfs.start_namenode
    - hadoop.hdfs.start_secondarynamenode

  'roles:jobtracker':
    - match: grain
    - hadoop.mapred.jobtracker

  'roles:tasktracker':
    - match: grain
    - hadoop.mapred.tasktracker
