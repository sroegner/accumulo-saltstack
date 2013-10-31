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

