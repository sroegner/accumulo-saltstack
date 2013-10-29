start-namenode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hdfs namenode 
    - user: hdfs
    - timeout: 60
    - onlyif: test -d {{ pillar.get('hdfs_nn_directories')|first() }}/current
