{% set hadoop_version = pillar['hadoop_version'] -%}
{% set hconfig_link   = '/etc/hadoop/conf' -%}
{% set hconfig = hconfig_link + '-' + hadoop_version -%}

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

{{ hconfig }}/core-site.xml:
  file.managed:
    - source: salt://hadoop/conf/core-site.xml.jinja
    - template: jinja

{{ hconfig }}/hdfs-site.xml:
  file.managed:
    - source: salt://hadoop/conf/hdfs-site.xml.jinja
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
