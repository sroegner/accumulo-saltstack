prep:
  salt.state:
    - tgt: '*'
    - sls:
      - hostsfile
      - hostsfile.hostname
      - ntp.server
      - sun-java
      - sun-java.env
      - jmxtrans

hadoop_services:
  salt.state:
    - tgt: 'G@roles:hadoop_master or G@roles:hadoop_slave'
    - tgt_type: compound
    - require:
      - salt: prep
    - sls:
      - hadoop
      - hadoop.snappy
      - hadoop.hdfs
      - hadoop.mapred
      - hadoop.yarn
      - hadoop.hdfs.load
      - hadoop.jmxtrans

zookeeper_service:
  salt.state:
    - tgt: 'G@roles:zookeeper'
    - tgt_type: compound
    - require:
        - salt: prep
    - sls:
        - zookeeper
        - zookeeper.jmxtrans
        - zookeeper.server

graphite_service:
  salt.state:
    - tgt: 'G@roles:monitor_master'
    - sls:
      - graphite
      - graphite.mysqldb

host_monitoring:
  salt.state:
    - tgt: 'G@roles:monitor'
    - tgt_type: compound
    - require:
      - salt: prep
    - sls:
      - graphite.diamond

accumulo_install:
  salt.state:
    - tgt: 'G@roles:accumulo_master or G@roles:accumulo_slave'
    - tgt_type: compound
    - require:
        - salt: hadoop_services
    - sls:
        - zookeeper
        - accumulo
        - accumulo.native

accumulo_service_init:
  salt.state:
    - tgt: 'G@roles:accumulo_master'
    - tgt_type: compound
    - require:
        - salt: zookeeper_service
        - salt: accumulo_install
    - sls:
        - accumulo.jmxtrans
        - accumulo.server.initialize
        - accumulo.server
        - accumulo.proxy
        - accumulo.development.testsuite

accumulo_service:
  salt.state:
    - tgt: 'G@roles:accumulo_slave'
    - tgt_type: compound
    - require:
        - salt: accumulo_service_init
    - sls:
        - accumulo.jmxtrans
        - accumulo.server
        - accumulo.proxy
        - accumulo.development.testsuite

dev_env:
  salt.state:
    - tgt: 'G@roles:development'
    - tgt_type: compound
    - sls:
        - maven
