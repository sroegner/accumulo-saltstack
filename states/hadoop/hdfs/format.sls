# TODO: make this work with hadoop 1
format-namenode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hdfs namenode -format | tee
    - user: hdfs
    - unless: test -d {{ pillar.get('hdfs_nn_directories')|first() }}/current
