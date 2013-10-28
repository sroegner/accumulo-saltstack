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
