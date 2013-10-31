{% if 'namenode' in grains['roles'] %}
include:
  - hadoop.hdfs.format

hadoop-namenode:
  service:
    - running
    - enable: True
    - require:
      - cmd.run: format-namenode
      - file.managed: hadoop-init-scripts
{% endif %}