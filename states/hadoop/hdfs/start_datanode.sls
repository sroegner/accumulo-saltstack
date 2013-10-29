start-datanode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hdfs datanode 
    - user: hdfs
    - timeout: 60
    - onlyif: test -d {{ pillar.get('hdfs_dn_directories')|first() }}
