{% set hadoop_version = pillar['hadoop_version'] %}
{% set hadoop_version_name = 'hadoop' + hadoop_version %}
{% set hadoop_tgz       = hadoop_version_name + '.tar.gz' %}
{% set hadoop_tgz_path  = '/downloads/' + hadoop_tgz %}
{% set hadoop_alt_home  = '/usr/lib/hadoop' %}
{% set hadoop_real_home = '/usr/lib/' + hadoop_version_name %}

{{ hadoop_tgz_path }}:
  file.managed:
    - source: http://sroegner-install.s3.amazonaws.com/{{ hadoop_tgz }}
    - source_hash: md5=bedb18412b3d5f7227ad19b6714dd6e0

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

rename-dist-conf:
  cmd.run:
    - name: mv {{ hadoop_real_home }}/etc/hadoop {{ hadoop_real_home }}/etc/hadoop.backup
    - unless: test -L {{ hadoop_real_home }}/etc/hadoop

{{ hadoop_real_home }}/etc/hadoop:
  file.symlink:
    - target: {{ pillar.get('hadoop_conf') }}
    - require:
      - cmd: rename-dist-conf

