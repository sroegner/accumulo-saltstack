hadoop:
  version: {{ grains.get('hadoop_version', '1.2.1') }}
  source: 'http://www.us.apache.org/dist/hadoop/common/hadoop-1.2.1/hadoop-1.2.1-bin.tar.gz'
  source_hash: md5=d9d9e9a5343cb741d78a3d4c22d0bb0f
  config:
    - tmp_dir: /var/lib/hadoop/tmp
    - directory: /etc/hadoop/conf
    - core-site:
      io.native.lib.available:
        value: true
      io.file.buffer.size:
        value: 65536
      fs.trash.interval:
        value: 60

