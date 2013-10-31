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
