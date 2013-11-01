{% if 'hadoop_slave' in grains['roles'] %}

include:
  - hadoop.install

hadoop-tasktracker:
  service.running:
    - enable: True
    - require:
      - file.managed: hadoop-init-scripts
{% endif %}