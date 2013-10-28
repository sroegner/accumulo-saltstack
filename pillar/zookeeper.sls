zookeeper_uid: 6030
zookeeper_version: {{ grains.get('zookeeper_version', '3.4.5') }}
zookeeper_data_dir: {{ grains.get('zookeeper_data_dir', '/var/lib/zookeeper/data') }}