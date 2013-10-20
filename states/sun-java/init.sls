{% set java_base_path = "/downloads/java/" %}
{% set java_tgz = "jdk-7u9-linux-x64.tar.gz" %}
{% set java_tgz_path = java_base_path + java_tgz %}
{% set java_path = java_base_path + "jdk1.7.0_09" %}

{{ java_base_path }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{{ java_tgz_path }}:
  file.managed:
    - source: salt://sun-java/{{ java_tgz }}
    - user: root
    - group: root
    - mode: 644  
    - require:
      - file: {{ java_base_path }}
  cmd.run:
    - require: 
      - file.managed: {{ java_tgz_path }}
    - name: tar zxvf {{ java_tgz_path }} -C {{ java_base_path }} 
    - unless: test -d {{ java_path }}
 
/etc/alternatives/java:
  file.symlink:
    - target: {{ java_path }}/bin/java 
    - require:
      - cmd: {{ java_tgz_path }}

