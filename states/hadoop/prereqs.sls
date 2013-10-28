hadoop:
  group.present:
    - gid: {{ pillar['hadoop_gid'] }}
  file.directory:
    - user: root
    - group: hadoop
    - mode: 775
    - names:
      - /var/log/hadoop
      - /var/run/hadoop
      - /var/lib/hadoop

{% set hadoop_users = ['hdfs','mapred','yarn'] %}
{% for username in hadoop_users %}
{% set uid = pillar[username+'_uid'] %}
{% set usr_home = '/home/' + username %}

{{ username }}:
  group.present:
    - gid: {{ uid }}
  user.present:
    - uid: {{ uid }}
    - gid: {{ uid }}
    - home: {{ usr_home }}
    - groups: ['hadoop']
    - require:
      - group: hadoop
      - group: {{ username }}
  file.directory:
    - user: {{ username }}
    - group: hadoop
    - names:
      - /var/log/hadoop/{{ username }}
      - /var/run/hadoop/{{ username }}
      - /var/lib/hadoop/{{ username }}
    - require:
      - file.directory: /var/lib/hadoop
      - file.directory: /var/run/hadoop
      - file.directory: /var/log/hadoop

{{ usr_home }}/.bashrc:
  file.append:
    - text:
      - export PATH=$PATH:/usr/lib/hadoop/bin:/usr/lib/hadoop/sbin

{% endfor %}

{% for dir in pillar['hdfs_directories'] %}
{{ dir }}:
  file.directory:
    - user: root
    - group: root
    - makedirs: True
{% endfor %}

{{ pillar.get('hadoop_temp_directory') }}:
  file.directory:
    - user: hdfs
    - group: hadoop
    - mode: 775

{% for dir in pillar['hdfs_mapred_directories'] %}
{{ dir }}:
  file.directory:
    - user: mapred
    - group: hadoop
    - mode: 755
    - makedirs: True
    - require:
      - user: mapred
{% endfor %}

/etc/security/limits.d/99-hadoop.conf:
  file.managed:
    - source: salt://hadoop/99-hadoop.conf.jinja
    - template: jinja
