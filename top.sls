base:
  '*':
    - hostsfile
    - ntp.server

  'G@roles:hadoop_master or G@roles:hadoop_slave or G@roles:accumulo_master or G@roles:accumulo_slave':
    - match: compound
    - sun-java
    - jmxtrans

  'G@roles:hadoop_master or G@roles:hadoop_slave':
    - match: compound
    - hadoop
    - hadoop.snappy
    - hadoop.hdfs
    - hadoop.mapred
    - hadoop.yarn
    - hadoop.jmxtrans

  'G@roles:accumulo_master or G@roles:accumulo_slave':
    - match: compound
    - zookeeper
    - accumulo
    - accumulo.server
    - accumulo.proxy
    - accumulo.jmxtrans

  'roles:zookeeper':
    - match: grain
    - zookeeper.server
    - zookeeper.jmxtrans

  'roles:development':
    - match: grain
    - mvn
    - accumulo.development

  'roles:monitor_master':
    - match: grain
    - graphite

  'roles:monitor':
    - match: grain
    - graphite.diamond

