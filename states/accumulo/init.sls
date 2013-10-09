/downloads/apache/accumulo/accumulo-1.5.0-bin.tar.gz:
  file.managed:
    - source: salt://accumulo/accumulo-1.5.0-bin.tar.gz
    - user: root
    - group: root
    - mode: 644  
    - order: 1

install accumulo:
  cmd.run:
    - name: cd /downloads/apache/accumulo/; tar zxvf *.gz > /downloads/apache/accumulo/.installed
    - unless: stat /downloads/apache/accumulo/.installed
    - order: 2

increase file max:
  cmd.run:
    - name: sysctl fs.file-max=65536
    
{{ pillar['ACCUMULO_HOME'] }}/conf:
  file.recurse:
    - source: salt://accumulo/conf
    - include_empty: True
    - file_mode: 744
    - order: 3
    - template: jinja

{{ pillar['ACCUMULO_HOME'] }}/proxy:
  file.recurse:
    - source: salt://accumulo/proxy
    - include_empty: True
    - file_mode: 744
    - order: 3
    - template: jinja


initialize accumulo instance:
  cmd.run:
    - name: {{ pillar['ACCUMULO_HOME'] }}/bin/accumulo init --instance-name {{ pillar['instance-name']}} --password {{ pillar['instance-password'] }}

start accumulo:
  cmd.run:
   - name: {{ pillar['ACCUMULO_HOME'] }}/bin/start-all.sh
   - env:
      JAVA_HOME: {{ pillar['JAVA_HOME'] }}
      ZOOKEEPER_HOME: {{ pillar['ZOOKEEPER_HOME'] }}
      HADOOP_HOME: {{ pillar['HADOOP_HOME'] }}
      ACCUMULO_HOME: {{ pillar['ACCUMULO_HOME'] }}
   - unless: true 

start proxy:
  cmd.run:
   - name: {{ pillar['ACCUMULO_HOME'] }}/bin/accumulo proxy -p proxy/proxy.properties &   
   - unless: true
