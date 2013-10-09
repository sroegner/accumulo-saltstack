hadoop:
  user.present:
    - fullname: Hadoop User 
    - shell: /bin/bash
    - home: /downloads/apache/hadoop
    - groups:
      - {{ pillar['sudoer-group'] }} 

/data/hadoop/name:
  file.directory:
    - user: hadoop 
    - group: hadoop 
    - mode: 744
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

/data/hadoop/namesecondary:
  file.directory:
    - user: hadoop 
    - group: hadoop 
    - mode: 744
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

/data/hadoop/data:
  file.directory:
    - user: hadoop 
    - group: hadoop 
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

/data/hadoop/tmp:
  file.directory:
    - user: hadoop 
    - group: hadoop 
    - mode: 744
    - makedirs: True
    - recurse:
      - user
      - group
      - mode

/downloads/apache/hadoop/hadoop-1.0.4.tar.gz:
  file.managed:
    - source: salt://hadoop/hadoop-1.0.4.tar.gz
    - user: root
    - group: root
    - mode: 644  
    - order: 1
  cmd.run:
    - name: cd /downloads/apache/hadoop/; tar zxvf *.gz > /downloads/apache/hadoop/hadoop-1.0.4/.installed
    - unless: stat /downloads/apache/hadoop/hadoop-1.0.4/.installed
    - order: 1

/downloads/apache/hadoop/hadoop-1.0.4/conf:
  file.recurse:
    - source: salt://hadoop/conf
    - include_empty: True
    - file_mode: 744


/etc/security/limits.conf:
    file.append:
      - text :
        - '*       soft    nofile  16384'
        - '*       hard    nofile  16384'

/etc/sysctl.conf:
    file.append:
      - text :
        - 'fs.epoll.max_user_instances = 4096'
        - 'vm.swappiness = 8'

format namenode:
  cmd.run: 
    - name: yes Y | bin/hadoop namenode -format |tee /data/hadoop/name/.formated
    - cwd: {{ pillar['HADOOP_HOME'] }}
    - unless: stat /data/hadoop/name/.formated

run namenode:
  cmd.run: 
    - cwd: {{ pillar['HADOOP_HOME'] }}
    - name: bin/hadoop-daemon.sh start namenode
    - unless: {{ pillar['JAVA_HOME'] }}/bin/jps |grep NameNode

run datanode:
  cmd.run: 
    - cwd: {{ pillar['HADOOP_HOME'] }}
    - name: bin/hadoop-daemon.sh start datanode 
    - unless: {{ pillar['JAVA_HOME'] }}/bin/jps |grep DataNode

