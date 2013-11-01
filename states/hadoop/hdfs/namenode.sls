{% if 'hadoop_master' in grains['roles'] %}
include:
  - hadoop.prereqs
  - hadoop.hdfs.format

hadoop-namenode:
  service:
    - running
    - enable: True
    - require:
      - cmd.run: format-namenode
      - file.managed: hadoop-init-scripts

{% endif %}
