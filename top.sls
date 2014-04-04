base:
  '*':
    - hostsfile
    - hostsfile.hostname
    - ntp.server

  'G@roles:hadoop_master or G@roles:hadoop_slave or G@roles:accumulo_master or G@roles:accumulo_slave':
    - match: compound
    - sun-java
    - sun-java.env
    - jmxtrans

  'G@roles:hadoop_master or G@roles:hadoop_slave':
    - match: compound
    - hadoop
    - hadoop.snappy
    - hadoop.hdfs
    - hadoop.mapred
    - hadoop.yarn
    - hadoop.jmxtrans

  'roles:zookeeper':
    - match: grain
    - zookeeper.server
    - zookeeper.jmxtrans

  'G@roles:accumulo_master or G@roles:accumulo_slave':
    - match: compound
    - zookeeper
    - accumulo
    - accumulo.native
    - accumulo.server.initialize
    - accumulo.server
    - accumulo.proxy
    - accumulo.jmxtrans
    - accumulo.development.testsuite

  'roles:development':
    - match: grain
    - maven
    - accumulo.development.sources

  'roles:monitor_master':
    - match: grain
    - graphite

  'roles:monitor':
    - match: grain
    - graphite.diamond

