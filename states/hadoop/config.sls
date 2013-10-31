include:
  - hadoop.install

{% set hadoop_version = pillar['hadoop_version'] %}
{% set hconfig_link   = pillar['hadoop_conf'] %}
{% set hconfig = hconfig_link + '-' + hadoop_version %}
{% set hconfig_dist = hconfig_link + '.dist' %}

conf-dirs:
  file.directory:
    - name: {{ hconfig }}
    - makedirs: true
    - user: root
    - group: root
  alternatives.install:
    - name: hadoop-conf-link
    - link: {{ hconfig_link }}
    - path: {{ hconfig }}
    - priority: 30
    - require:
      - file.directory: {{ hconfig }}

/etc/profile.d/hadoop.sh:
  file.managed:
    - source: salt://hadoop/conf/hadoop.sh.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root

{{ hconfig }}/core-site.xml:
  file.managed:
    - source: salt://hadoop/conf/core-site.xml.jinja
    - template: jinja

{{ hconfig }}/hdfs-site.xml:
  file.managed:
    - source: salt://hadoop/conf/hdfs-site.xml.jinja
    - template: jinja

{{ hconfig }}/mapred-site.xml:
  file.managed:
    - source: salt://hadoop/conf/mapred-site.xml.jinja
    - template: jinja

{{ hconfig }}/hadoop-env.sh:
  file.managed:
    - source: salt://hadoop/conf/hadoop-env.sh.jinja
    - template: jinja

{{ hconfig }}/masters:
  file.managed:
    - source: salt://hadoop/conf/masters.jinja
    - template: jinja

{{ hconfig }}/slaves:
  file.managed:
    - source: salt://hadoop/conf/slaves.jinja
    - template: jinja

{{ hconfig }}/log4j.properties:
  file.copy:
    - source: {{ hconfig_dist }}/log4j.properties
    - user: root
    - group: root
    - mode: 644
