include:
  - hadoop.prereqs
  - hadoop.init_scripts

{% set hadoop_version = pillar['hadoop_version'] %}
{% set hadoop_version_name = 'hadoop-' + hadoop_version %}
{% set hadoop_tgz = hadoop_version_name + '.tar.gz' %}
{% set hadoop_tgz_path  = '/downloads/' + hadoop_tgz %}
{% set hadoop_alt_home  = '/usr/lib/hadoop' %}
{% set hadoop_real_home = '/usr/lib/' + hadoop_version_name %}
{% set hconfig_link   = pillar['hadoop_conf'] %}
{% set hconfig = hconfig_link + '-' + hadoop_version %}
{% set hconfig_dist = hconfig_link + '.dist' %}

/etc/hadoop:
  file.directory:
    - user: root
    - group: root

{{ hadoop_tgz_path }}:
  file.managed:
    - source: http://sroegner-install.s3.amazonaws.com/{{ hadoop_tgz }}
    - source_hash: md5={{ pillar['hadoop_tgz_md5'] }}

install-hadoop-dist:
  cmd.run:
    - name: tar xzf {{ hadoop_tgz_path }}
    - cwd: /usr/lib
    - unless: test -d {{ hadoop_real_home }}/lib
    - require:
      - file.managed: {{ hadoop_tgz_path }}
  alternatives.install:
    - name: hadoop-home-link
    - link: {{ hadoop_alt_home }}
    - path: {{ hadoop_real_home }}
    - priority: 30
    - require:
      - cmd.run: install-hadoop-dist

# chown all files to root:root
{{ hadoop_real_home }}:
  file.directory:
    - user: root
    - group: root
    - recurse:
      - user
      - group
    - require:
      - cmd.run: install-hadoop-dist

{% if pillar['hadoop_major_version'] == '1' %}
{% set hadoop_real_conf = hadoop_real_home + '/conf' %}
{% else %}
{% set hadoop_real_conf = hadoop_real_home + '/etc/hadoop' %}
{% endif %}

move-hadoop-dist-conf:
  cmd.run:
    - name: mv  {{ hadoop_real_conf }} {{ hconfig_dist }}
    - unless: test -L {{ hadoop_real_conf }}
    - onlyif: test -d {{ hadoop_real_conf }}
    - require:
      - file.directory: {{ hadoop_real_home }}
      - file.directory: /etc/hadoop

{{ hadoop_real_conf }}:
  file.symlink:
    - target: {{ pillar.get('hadoop_conf') }}
    - require:
      - cmd: move-hadoop-dist-conf

/etc/profile.d/hadoop.sh:
  file.managed:
    - source: salt://hadoop/files/hadoop.sh.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root

{{ hconfig }}:
  file.recurse:
    - source: salt://hadoop/conf
    - template: jinja
    - require:
      - file: /etc/profile.d/hadoop.sh

hadoop-conf-link:
  alternatives.install:
    - link: {{ hconfig_link }}
    - path: {{ hconfig }}
    - priority: 30
    - require:
      - file.directory: {{ hconfig }}

{{ hconfig }}/log4j.properties:
  file.copy:
    - source: {{ hconfig_dist }}/log4j.properties
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: {{ hconfig }}
      - alternatives.install: hadoop-conf-link