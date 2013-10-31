{% if 'jobtracker' in grains['roles'] %}

include:
  - hadoop.config

hadoop-jobtracker:
  service.running:
    - enable: True
    - require:
      - file.managed: hadoop-init-scripts
{% endif %}