{% set java_version_name = pillar['java_version_name'] %}
{% set java_tgz = pillar['java_tgz'] %}
{% set java_tgz_path = '/downloads/' + java_tgz %}
{% set java_home = pillar['JAVA_HOME'] %}
{% set jprefix = '/usr/lib/java' %}
{% set java_real_home = jprefix + '/' + pillar['java_version_name'] %}

/usr/lib/java:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/usr/java:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{{ java_tgz_path }}:
  file.managed:
    - source: http://sroegner-install.s3.amazonaws.com/{{ java_tgz }}
    - source_hash: md5=92f56f903483750818ffc3a4f41fe779

unpack-jdk-tarball:
  cmd.run:
    - name: tar xzf {{ java_tgz_path }}
    - cwd: {{ jprefix }}
    - unless: test -d {{ java_real_home }}
    - require:
      - file.directory: {{ jprefix }}
      - file.managed: {{ java_tgz_path }}
  alternatives.install:
    - name: java-home-link
    - link: {{ java_home }}
    - path: {{ java_real_home }}
    - priority: 30
    - require:
      - file.directory: /usr/java

jdk-config:
  file.managed:
    - name: /etc/profile.d/java.sh
    - source: salt://sun-java/java.sh.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root
