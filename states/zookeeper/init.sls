{% set zookeeper_dir = "/downloads/apache/zookeeper/" %}
{% set zookeeper_version = "3.4.5" %}
{% set zookeeper_tgz = "zookeeper-" + zookeeper_version + ".tar.gz" %}
{% set zookeeper_tgz_path = zookeeper_dir + zookeeper_tgz %}

{{ zookeeper_dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

{{ zookeeper_tgz_path }}:
  file.managed:
    - source: salt://zookeeper/{{ zookeeper_tgz }}
    - user: root
    - group: root
    - mode: 644  
    - require:
      - file: {{ zookeeper_dir }}
  cmd.run:
    - require: 
      - file.managed: {{ zookeeper_tgz_path }}
    - name: tar zxf {{ zookeeper_tgz_path }} -C {{ zookeeper_dir }}
    - unless: test -d {{ zookeeper_dir }}/zookeeper-{{ zookeeper_version }}
    - require_in: 
      - file.managed: {{ pillar['ZOOKEEPER_HOME'] }}/conf/zoo.cfg
      - file.managed: {{ pillar['ZOOKEEPER_HOME'] }}/bin/zkEnv.sh

{{ pillar['ZOOKEEPER_HOME'] }}/conf/zoo.cfg:
  file.managed:
    - source: salt://zookeeper/zoo.cfg
    - user: root
    - group: root
    - mode: 644  
    - template: jinja

{{ pillar['ZOOKEEPER_HOME'] }}/bin/zkEnv.sh:
  file.managed:
    - source: salt://zookeeper/zkEnv.sh
    - user: root
    - group: root
    - mode: 644  
    - template: jinja

/data/zookeeper:
  file.directory:
    - user: root 
    - group: root 
    - mode: 755
    - makedirs: True

/etc/init/zookeeper.conf:
  file.managed:
    - source: salt://zookeeper/zookeeper-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

zookeeper:
  service.running
