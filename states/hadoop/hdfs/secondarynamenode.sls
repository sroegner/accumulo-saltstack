{% for dir in pillar['hdfs_snn_directories'] %}
{{ dir }}:
  file.directory:
    - user: hdfs
    - group: hadoop
    - mode: 755
    - makedirs: True
    - require:
      - user: hdfs
{% endfor %}
include:
  - hadoop.hdfs.start_namenode

hadoop-secondarynamenode:
  service:
    - running
    - enable: True
    - require:
      - service.running: hadoop-namenode