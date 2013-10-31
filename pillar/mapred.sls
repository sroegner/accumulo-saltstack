hadoopconf-mapred-site:
  mapred.framework.name:
    value: yarn
  mapred.map.memory.mb:
    value: 1536
  mapred.map.java.opts:
    value: -Xmx1024M
  mapred.reduce.memory.mb:
    value: 3072
  mapred.reduce.java.opts:
    value: -Xmx1024m
  mapred.task.io.sort.mb:
    value: 512
  mapred.task.io.sort.factor:
    value: 100
  mapred.reduce.shuffle.parallelcopies:
    value: 50
