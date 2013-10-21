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
  'roles:accumulo':
    - match: grain
    - sun-java
    - zookeeper
    - hadoop
    - accumulo
