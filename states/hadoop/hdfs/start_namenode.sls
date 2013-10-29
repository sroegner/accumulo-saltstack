start-namenode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hdfs namenode 
    - user: hdfs
    - onlyif: test -d {{ pillar.get('hdfs_nn_directories')|first() }}/current

