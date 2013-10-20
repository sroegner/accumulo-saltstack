{% set hadoop_version = "1.0.4" %}
{% set hadoop_base_dir = "/downloads/apache/hadoop/" %}
{% set hadoop_home = "/downloads/apache/hadoop/hadoop-" + hadoop_version %}
{% set hadoop_data_dir = "/data/hadoop/" %}
{% set hadoop_tgz = "hadoop-" + hadoop_version + ".tar.gz" %}
{% set hadoop_tgz_path = hadoop_base_dir + hadoop_tgz %}

/downloads/apache:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

{{ hadoop_base_dir }}:
  file.directory:
    - user: hadoop
    - group: hadoop
    - mode: 755

hadoop:
  user.present:
    - fullname: Hadoop User 
    - shell: /bin/bash
    - home: {{ hadoop_base_dir }}
    - groups:
      - {{ pillar['sudoer-group'] }} 

{% for dir_path in [ "name", "namesecondary", "data", "tmp" ] %}
{{ hadoop_data_dir }}/{{ dir_path }}:
  file.directory:
    - user: hadoop 
    - group: hadoop 
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
{% endfor %}

{{ hadoop_tgz_path }}:
  file.managed:
    - source: salt://hadoop/{{ hadoop_tgz }}
    - user: root
    - group: root
    - mode: 644  
  cmd.run:
    - name: tar xfz {{ hadoop_tgz_path }} -C {{ hadoop_base_dir }}
    - unless: test -d {{ hadoop_home }}
    - require:
      - file: {{ hadoop_tgz_path }}

{{ hadoop_home }}/conf:
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
    - name: yes Y | bin/hadoop namenode -format |tee {{ hadoop_data_dir }}/name/.formated
    - cwd: {{ hadoop_home }}
    - unless: stat {{ hadoop_data_dir }}/name/.formated
    - require:
      - cmd: {{ hadoop_tgz_path }}

/etc/init/hadoop-datanode.conf:
  file.managed:
    - source: salt://hadoop/hadoop-datanode-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/init/hadoop-namenode.conf:
  file.managed:
    - source: salt://hadoop/hadoop-namenode-upstart.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

hadoop-datanode:
  service.running:
    - require:
      - file: /etc/init/hadoop-namenode.conf
    - order: last

hadoop-namenode:
  service.running:
    - require:
      - file: /etc/init/hadoop-namenode.conf
    - order: last

