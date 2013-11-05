zookeeper:
  source: 'http://www.us.apache.org/dist/zookeeper/zookeeper-3.4.5/zookeeper-3.4.5.tar.gz'
  source_hash: sha1=fd921575e02478909557034ea922de871926efc7
  version: {{ grains.get('zookeeper_version', '3.4.5') }}
  prefix: /usr/lib/zookeeper
  data_dir: {{ grains.get('zookeeper_data_dir', '/var/lib/zookeeper/data') }}
  port: 2181
