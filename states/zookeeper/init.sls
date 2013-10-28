{% set zookeeper_version = pillar['zookeeper_version'] %}
{% set zookeeper_alt_home = pillar['ZOOKEEPER_HOME'] %}
{% set zookeeper_real_home = '/usr/lib/zookeeper' + '-' + zookeeper_version %}
{% set zookeeper_conf = '/etc/zookeeper/conf-' + zookeeper_version %}

{% set zookeeper_tgz = "zookeeper-" + zookeeper_version + ".tar.gz" %}
{% set zookeeper_tgz_path = '/downloads/' + zookeeper_tgz %}

{{ zookeeper_conf }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

zookeeper:
  group.present:
    - gid: {{ pillar.get('zookeeper_uid') }}
  user.present:
    - uid: {{ pillar.get('zookeeper_uid') }}
    - gid: {{ pillar.get('zookeeper_uid') }}

zk-directories:
  file.directory:
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - makedirs: True
    - names:
      - /var/run/zookeeper
      - /var/lib/zookeeper
      - /var/log/zookeeper

zookeeper-config-link:
  alternatives.install:
    - link: /etc/zookeeper/conf
    - path: {{ zookeeper_conf }}
    - priority: 30

# download the tarball
{{ zookeeper_tgz_path }}:
  file.managed:
    - source: http://sroegner-install.s3.amazonaws.com/{{ zookeeper_tgz }}
    - source_hash: md5=f64fef86c0bf2e5e0484d19425b22dcb

install-zookeeper-dist:
  cmd.run:
    - name: tar xzf {{ zookeeper_tgz_path }}
    - cwd: /usr/lib
    - unless: test -d {{ zookeeper_real_home }}/lib
    - require:
      - file.managed: {{ zookeeper_tgz_path }}
  alternatives.install:
    - name: zookeeper-home-link
    - link: {{ zookeeper_alt_home }}
    - path: {{ zookeeper_real_home }}
    - priority: 30
    - require:
      - cmd.run: install-zookeeper-dist

{{ zookeeper_conf }}/configuration.xsl:
  file.copy:
    - source: {{ zookeeper_real_home }}/conf.backup/configuration.xsl
    - user: root
    - group: root
    - mode: 644

{{ zookeeper_conf }}/log4j.properties:
  file.copy:
    - source: {{ zookeeper_real_home }}/conf.backup/log4j.properties
    - user: root
    - group: root
    - mode: 644

{{ zookeeper_conf }}/zoo.cfg:
  file.managed:
    - source: salt://zookeeper/zoo.cfg
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{{ zookeeper_conf }}/zookeeper-env.sh:
  file.managed:
    - source: salt://zookeeper/zookeeper-env.sh
    - user: root
    - group: root
    - mode: 755

rename-dist-conf:
  cmd.run:
    - name: mv {{ zookeeper_real_home }}/conf {{ zookeeper_real_home }}/conf.backup
    - unless: test -L {{ zookeeper_real_home }}/conf

{{ zookeeper_real_home }}/conf:
  file.symlink:
    - target: {{ zookeeper_conf }}
    - require:
      - cmd: rename-dist-conf
