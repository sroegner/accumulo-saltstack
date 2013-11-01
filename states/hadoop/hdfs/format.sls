{% if 'hadoop_master' in grains['roles'] %}
{% set test_folder = pillar['hdfs_nn_directories']|first() + '/current' %}

include:
  - sun-java
  - hadoop.install

{% for dir in pillar['hdfs_nn_directories'] %}
{{ dir }}:
  file.directory:
    - user: hdfs
    - group: hadoop
    - mode: 755
    - makedirs: True
    - require:
      - user: hdfs
{% endfor %}

format-namenode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hadoop namenode -format -force
    - user: hdfs
    - unless: test -d {{ test_folder }}
    - require:
      - file.managed: jdk-config
{% endif %}
