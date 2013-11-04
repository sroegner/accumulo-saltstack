{%- set addrs = salt['mine.get']('*', 'network.ip_addrs') %}
{%- set clusterdomain = salt['grains.get']('clusterdomain', 'accumulo-ec2-test.com') %}
{%- if addrs %}
{%- for name, addrlist in addrs.items() %}

{{ name }}-host-entry:
  host.present:
    - ip: {{ addrlist|first() }}
    - names:
      - {{ name }}.{{ clusterdomain }}
      - {{ name }}
    
{% endfor %}
{% endif %}

vm.swappiness:
  sysctl:
    - present
    - value: 10

vm.overcommit_memory:
  sysctl:
    - present
    - value: 0

