{% if 'namenode' in grains['roles'] %}
{% set test_folder = pillar['hdfs_nn_directories']|first() + '/current' %}

include:
  - sun-java
  - hadoop.config

format-namenode:
  cmd.run:
    - name: /usr/lib/hadoop/bin/hadoop namenode -format -force
    - user: hdfs
    - unless: test -d {{ test_folder }}
    - require:
      - file.managed: jdk-config
{% endif %}