{% if grains.get('virtual') == "VirtualBox" -%}
/root/.bashrc:
  file.append:
    - text:
      - alias high='salt '*' state.highstate'
{%  endif -%}


{% if grains.get('os_family') == "RedHat" -%}
/etc/ssh/shosts.equiv:
  file.managed:
    - source: salt://misc/ssh/shosts.equiv
    - template: jinja

/etc/ssh/ssh_config:
  file.managed:
    - source: salt://misc/ssh/ssh_config
    - template: jinja

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://misc/ssh/sshd_config
    - template: jinja

/etc/ssh/ssh_host_rsa_key:
  file.managed:
    - source: salt://misc/ssh/ssh_host_rsa_key
    - mode: '0600'

/etc/ssh/ssh_host_rsa_key.pub:
  file.managed:
    - source: salt://misc/ssh/ssh_host_rsa_key.pub

/etc/ssh/ssh_known_hosts:
  file.managed:
    - source: salt://misc/ssh/ssh_known_hosts
    - template: jinja

sshd:
  service:
    - running
    - enable: True
    - reload: True
    - watch:
      - file: /etc/ssh/sshd_config
      - file: /etc/ssh/ssh_host_rsa_key
      - file: /etc/ssh/shosts.equiv

{%  endif -%}

vm.swappiness:
  sysctl:
    - present
    - value: 10

vm.overcommit_memory:
  sysctl:
    - present
    - value: 0
