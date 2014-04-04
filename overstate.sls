prep:
    match: '*'
    sls:
        - hostsfile
        - hostsfile.hostname
        - ntp.server

hnode_prep:
    match: 'G@roles:hadoop_master or G@roles:hadoop_slave or G@roles:accumulo_master or G@roles:accumulo_slave'
    require:
        - prep
    sls:
        - sun-java
        - sun-java.env
        - jmxtrans

hadoop_services:
    match: 'G@roles:hadoop_master or G@roles:hadoop_slave'
    require:
        - prep
        - hnode_prep
    sls:
        - hadoop
        - hadoop.snappy
        - hadoop.hdfs
        - hadoop.mapred
        - hadoop.yarn
        - hadoop.hdfs.load
        - hadoop.jmxtrans

accumulo_install:
    match: 'G@roles:accumulo_master or G@roles:accumulo_slave'
    require:
        - hadoop_services
    sls:
        - zookeeper
        - accumulo
        - accumulo.native

zookeeper_service:
    match: 'G@roles:zookeeper'
    require:
        - prep
        - hnode_prep
    sls:
        - zookeeper.jmxtrans
        - zookeeper.server

accumulo_service_init:
    match: 'G@roles:accumulo_master'
    require:
        - zookeeper_service
    sls:
        - accumulo.jmxtrans
        - accumulo.server.initialize
        - accumulo.server
        - accumulo.proxy
        - accumulo.development.testsuite

accumulo_service:
    match: 'G@roles:accumulo_slave'
    require:
        - accumulo_service_init
    sls:
        - accumulo.jmxtrans
        - accumulo.server
        - accumulo.proxy
        - accumulo.development.testsuite

dev_env:
    match: 'G@roles:development'
    sls:
        - maven

graphite_service:
    match: 'G@roles:monitor_master'
    sls:
        - graphite
        - graphite.mysqldb

host_monitoring:
    match: 'G@roles:monitor'
    require:
        - prep
    sls:
        - graphite.diamond

