hadoop_version: {{ grains.get('hadoop_version', '2.2.0') }}

hadoop_gid: 6000
hdfs_uid: 6001
mapred_uid: 6002
yarn_uid: 6003

namenode_port: 8020
namenode_http_port: 50070
secondarynamenode_http_port: 50090

hdfs_directories:
{% for disk in grains['data_disks'] %}
  - {{ disk }}/hdfs
{% endfor %}

hdfs_nn_directories:
{% for disk in grains['data_disks'] %}
  - {{ disk }}/hdfs/nn
{% endfor %}

hdfs_dn_directories:
{% for disk in grains['data_disks'] %}
  - {{ disk }}/hdfs/dn
{% endfor %}

hdfs_snn_directories:
{% for disk in grains['data_disks'] %}
  - {{ disk }}/hdfs/snn
{% endfor %}

hdfs_mapred_directories:
{% for disk in grains['data_disks'] %}
  - {{ disk }}/hdfs/mapred
{% endfor %}

hadoop_temp_directory: /var/lib/hadoop/temp
hadoop_conf: /etc/hadoop/conf

hadoopconf-core-site:
  io.native.lib.available:
    value: true
  io.file.buffer.size:
    value: 65536
  fs.trash.interval:
    value: 60

hadoopconf-hdfs-site:
  dfs.replication:
    value: 1
  dfs.permission:
    value: false
  dfs.durable.sync:
    value: true
  dfs.datanode.synconclose:
    value: true
