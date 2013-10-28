JAVA_HOME: {{ grains.get('java_home', '/usr/java/default') }}
HADOOP_HOME: {{ grains.get('hadoop_home', '/usr/lib/hadoop') }}
ZOOKEEPER_HOME: {{ grains.get('zookeeper_home', '/usr/lib/zookeeper') }}
ACCUMULO_HOME: {{ grains.get('accumulo_home', '/usr/lib/accumulo') }}

