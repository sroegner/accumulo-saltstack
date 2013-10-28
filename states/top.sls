base:
  '*':
    - misc.prereqs
    - sun-java
    - hadoop.prereqs

  'roles:zookeeper':
    - match: grain
    - zookeeper
    - zookeeper.start
