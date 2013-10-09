base:
  'server-*':
    - pipeline 
    - monit
    - date
    - ntp
    - sudoers
    - ssh
  'zookeeper':
    - sudoers
    - ssh
    - ntp
