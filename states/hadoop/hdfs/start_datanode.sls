{% if 'datanode' in grains['roles'] %}
hadoop-datanode:
  service:
    - running
    - enable: True
{% endif %}