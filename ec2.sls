{%- set fqdn = grains['id'] %}
{%- set addrs = salt['mine.get']('*', 'network.ip_addrs') %}

{%- if grains['os'] == 'Amazon' %}

{%- if addrs %}
{%- for name, addrlist in addrs.items() %}
{{ name }}-host-entry:
  host.present:
    - ip: {{ addrlist|first() }}
    - names:
      - {{ name }}
{% endfor %}
{% endif %}

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
{%- if 'accumulo_master' in salt['grains.get']('roles', []) %}
      - 'su - accumulo -c "/usr/lib/accumulo/bin/start-all.sh"'
{%- endif %}

{%- endif %}


