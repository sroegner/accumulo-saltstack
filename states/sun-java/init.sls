/downloads/java/jdk-7u9-linux-x64.tar.gz:
  file.managed:
    - source: salt://sun-java/jdk-7u9-linux-x64.tar.gz
    - user: root
    - group: root
    - mode: 644  
  cmd.run:
    - require: 
      - file.managed: /downloads/java/jdk-7u9-linux-x64.tar.gz
    - name: cd /downloads/java/; tar zxvf *.gz > /downloads/java/.installed
    - unless: stat /downloads/java/jdk1.7.0_09/.installed
 
/etc/alternatives/java:
  file.symlink:
    - target: /downloads/java/jdk1.7.0_09/bin/java 

