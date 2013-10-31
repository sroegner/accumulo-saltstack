include:
  - hadoop.hdfs.start_namenode

hadoop-secondarynamenode:
  service:
    - running
    - enable: True
    - require:
      - service.running: hadoop-namenode