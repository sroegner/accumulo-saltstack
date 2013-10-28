java_version_name: jdk-linux-server-x64-1.7.0.45_22
java_tgz: {{ grains.get('java_tgz', 'jdk-linux-server-x64-1.7.0.45_22-bin.tar.gz') }}

{% if grains['os'] == 'RedHat' %}
sudoer-group: wheel
{% elif grains['os'] == 'Ubuntu' %}
sudoer-group: sudo
{% elif grains['os'] == 'Amazon' %}
sudoer-group: wheel
{% endif %}
