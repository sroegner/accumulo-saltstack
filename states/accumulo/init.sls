{% set accumulo_home = pillar['ACCUMULO_HOME'] %}
{% set accumulo_dir = "/downloads/apache/accumulo/" %}
{% set accumulo_version = "1.5.0" %}
{% set accumulo_tgz = "accumulo-" + accumulo_version + "-bin.tar.gz" %}
{% set accumulo_tgz_path = accumulo_dir + accumulo_tgz %}

{{ accumulo_tgz_path }}:
  file.managed:
    - source: salt://accumulo/{{ accumulo_tgz }}
    - user: root
    - group: root
    - mode: 644  
  cmd.run:
    - name: tar xfz {{ accumulo_tgz_path }} -C {{ accumulo_dir }}
    - unless: test -d {{ accumulo_home }}/bin
    - require:
      - file: {{ accumulo_tgz_path }}

/etc/sysctl.d/accumulo.conf:
  file.managed:
    - source: salt://accumulo/sysctl.conf
    - user: root
    - group: root
    - mode: 644
    
{{ pillar['ACCUMULO_HOME'] }}/conf:
  file.recurse:
    - source: salt://accumulo/conf
    - include_empty: True
    - file_mode: 644
    - dir_mode: 755
    - order: 3
    - template: jinja

{{ pillar['ACCUMULO_HOME'] }}/proxy:
  file.recurse:
    - source: salt://accumulo/proxy
    - include_empty: True
    - file_mode: 644
    - dir_mode: 755
    - order: 3
    - template: jinja

accumulo-init:
  cmd.run:
    - name: {{ pillar['ACCUMULO_HOME'] }}/bin/accumulo init --instance-name {{ pillar['instance-name']}} --password {{ pillar['instance-password'] }} && touch {{ accumulo_home }}/.initialized
    - unless: test -f {{ accumulo_home }}/.initialized
    - require:
      - file: {{ pillar['ACCUMULO_HOME'] }}/conf
      - file: {{ pillar['ACCUMULO_HOME'] }}/proxy
      - cmd: {{ accumulo_tgz_path }}

/etc/init/accumulo.conf:
  file.managed:
    - source: salt://accumulo/accumulo-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - cmd: accumulo-init

/etc/init/accumulo-proxy.conf:
  file.managed:
    - source: salt://accumulo/accumulo-proxy-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - cmd: accumulo-init

accumulo:
  service.running:
    - require:
      - file: /etc/init/accumulo.conf
      - service.running: hadoop-datanode
      - service.running: hadoop-namenode

accumulo-proxy:
  service.running:
    - require:
      - file: /etc/init/accumulo-proxy.conf
      - service.running: hadoop-datanode
      - service.running: hadoop-namenode

