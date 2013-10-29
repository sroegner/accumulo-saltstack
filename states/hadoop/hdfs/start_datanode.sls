start-datanode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hdfs datanode 
    - user: hdfs
    - onlyif: test -d {{ pillar.get('hdfs_nn_directories')|first() }}/current

