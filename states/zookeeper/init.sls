/tmp/zookeeper.tar.gz:
  file.managed:
    - source: salt://zookeeper/zookeeper-3.4.5.tar.gz
    - user: root
    - group: root
    - mode: 644  
  cmd.run:
    - require: 
      - file.managed: /tmp/zookeeper.tar.gz
    - name: cd /downloads/apache/zookeeper; tar zxvf /tmp/zookeeper.tar.gz 
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

zkServer.sh:
  cmd.run: 
    - name: {{ pillar['ZOOKEEPER_HOME'] }}/bin/zkServer.sh start
    - order: last


