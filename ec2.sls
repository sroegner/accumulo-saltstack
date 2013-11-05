{%- set clusterdomain = salt['grains.get']('clusterdomain', 'accumulo-ec2-test.com') %}
{%- set fqdn = grains['id'] + '.' + clusterdomain %}

{%- if grains['virtual'] == 'xen' %}

{%- if grains['os_family'] == 'RedHat' %}
/etc/sysconfig/network:
  file.replace:
    - pattern: HOSTNAME=localhost.localdomain
    - repl: HOSTNAME={{ fqdn }}
    - backup: false
{% endif %}

set-fqdn:
  cmd.run:
    - name: hostname {{ fqdn }}

/etc/rc.local:
  file.append:
    - text:
      - '# replace the IP'
      - 'IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null)'
      - 'HOSTNAME=$(hostname)'
      - 'sed -i "s/^.*${HOSTNAME}/${IP} ${HOSTNAME}/g" /etc/hosts'
      - 'service hadoop-namenode start'
      - 'service hadoop-secondarynamenode start'
      - 'service hadoop-datanode start'
      - 'service zookeeper start'
      - 'su - accumulo -c "/usr/lib/accumulo/bin/start-all.sh"'

{% endif %}
