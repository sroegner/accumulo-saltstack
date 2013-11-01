base:
  '*':
    - common
    - hadoop
    - mine
    - paths
    - secret
    - accumulo
    - zookeeper

  'roles:hadoop_master':
    - match: grain
    - hadoop.master

  'roles:hadoop_slave':
    - match: grain
    - hadoop.slave

