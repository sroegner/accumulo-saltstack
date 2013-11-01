{% if 'hadoop_master' in grains['roles'] %}

include:
  - hadoop.install
  - hadoop.hdfs.add_tempdir

hadoop-jobtracker:
  service.running:
    - enable: True
    - require:
      - file.managed: hadoop-init-scripts
      - cmd: add-temp

{% endif %}