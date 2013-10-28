# TODO: make this work with hadoop 1
format-namenode:
  cmd.run:
    - name: {{ pillar.get('hadoop_home') }}/bin/hdfs namenode -format | tee
    - user: {{ salt['pillar.get']('users:hadoop:hdfs:name') }}
    - unless: test -d {{ pillar.get('hdfs_nn_directories')|first() }}/current
