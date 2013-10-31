include:
  - hadoop.hdfs.start_datanode
  - hadoop.hdfs.start_namenode

{% set tmp = pillar['hadoop_temp_directory'] %}
# BIG FAT TODO: make this work _WITH_ the sticky bit set (that 1777 for the mode)

add-temp:
  cmd.run:
    - name: hadoop dfs -mkdir {{ tmp }} && hadoop dfs -chmod 777 {{ tmp }}
    - user: hdfs
    - shell: /bin/bash
    - unless: hadoop dfs -ls /tmp
    - env:
      - PATH: '/bin:/usr/bin:/usr/lib/hadoop/bin:/usr/lib/hadoop/sbin'
    - require:
      - file.managed: jdk-config
