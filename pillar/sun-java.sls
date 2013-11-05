java_home: /usr/lib/java

java:
  source: http://sroegner-install.s3.amazonaws.com/jdk-linux-server-x64-1.7.0.45_22-bin.tar.gz
  source_hash: md5=92f56f903483750818ffc3a4f41fe779
  version_name: jdk-linux-server-x64-1.7.0.45_22
  tgz: {{ grains.get('java_tgz', 'jdk-linux-server-x64-1.7.0.45_22-bin.tar.gz') }}
  prefix: /usr/share/java

