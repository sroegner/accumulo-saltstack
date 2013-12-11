base:
  '*':
    - tomcat
    - ec2
    - ntp.server
    - sun-java
    - zookeeper
    - hadoop
    - hadoop.snappy
    - hadoop.hdfs
    - hadoop.mapred
    - hadoop.yarn
    - hadoop.jmxtrans
    - accumulo
    - accumulo.server
    - accumulo.proxy
    - jmxtrans

  'roles:zookeeper':
    - match: grain
    - zookeeper.server

  'roles:development':
    - match: grain
    - mvn
    - accumulo.development

  'roles:monitor_master':
    - match: grain
    - graphite

