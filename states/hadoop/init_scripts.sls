#!py

def run():
  '''
  Add hadoop init.d start scripts according to hadoop roles of the node
  Returns nothing on Ubuntu/Debian
  '''

  config = {}

  if __grains__['os_family'] != 'RedHat':
    return config

  all_roles  = ['namenode','secondarynamenode','datanode','tasktracker','jobtracker','resourcemanager','nodemanager']
  node_roles = __grains__['roles']

  inter = list(set(node_roles).intersection(set(all_roles)))
  svcs  = ['/etc/init.d/hadoop-'+s for s in inter]

  config['hadoop-init-scripts'] = {
  'file.managed': [{
    'source': 'salt://hadoop/hadoop-component-init.d.jinja',
    'template': 'jinja',
    'mode': '755',
    'names' : svcs }],
  }

  return config
