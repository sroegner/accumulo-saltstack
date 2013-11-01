#hadoop_version: {{ grains.get('hadoop_version', '1.2.1') }}
hadoop_version: {{ grains.get('hadoop_version', '1.1.2') }}
hadoop_major_version: '1'
#hadoop_tgz_md5: 8d7904805617c16cb227d1ccbfe9385a
hadoop_tgz_md5: 5557aa1089ab9073d2a5c35c775cccad
hadoop_gid: 6000
hdfs_uid: 6001
mapred_uid: 6002
yarn_uid: 6003

namenode_port: 8020
namenode_http_port: 50070
secondarynamenode_http_port: 50090
jobtracker_port: 9001

hadoop_temp_directory: /tmp
hadoop_conf: /etc/hadoop/conf

hadoopconf-core-site:
  io.native.lib.available:
    value: true
  io.file.buffer.size:
    value: 65536
  fs.trash.interval:
    value: 60

{% set disks     = grains.get('hdfs_data_disks', ['/data']) %}
{% set mr_disks  = grains.get('mapred_data_disks', ['/data']) %}
{% set all_disks = (disks and mr_disks) %}

hdfs_directories:
{% for disk in all_disks %}
  - {{ disk }}/hdfs
{% endfor %}

hdfs_nn_directories:
{% for disk in disks %}
  - {{ disk }}/hdfs/nn
{% endfor %}

hdfs_dn_directories:
{% for disk in disks %}
  - {{ disk }}/hdfs/dn
{% endfor %}

hdfs_snn_directories:
{% for disk in disks %}
  - {{ disk }}/hdfs/snn
{% endfor %}

mapred_local_directories:
{% for disk in mr_disks %}
  - {{ disk }}/mapred
{% endfor %}

hadoopconf-hdfs-site:
  dfs.replication:
    value: 1
  dfs.permission:
    value: false
  dfs.durable.sync:
    value: true
  dfs.datanode.synconclose:
    value: true
