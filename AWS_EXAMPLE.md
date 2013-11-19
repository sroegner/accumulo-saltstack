Using accumulo-saltstack on EC2
=

Salt Master Configuration
-

This is the currently expected Salt master configuration.
Depending on your provisioning model (either using a single master or spawning new masters as part of salt-cloud maps) this needs to go into

In the former scenario, this is your __etc/salt/master__ file.

    user: root
    log_level: info
    peer:
      .*:
        - test.*
        - grains.*
    fileserver_backend:
      - roots
      - git
    file_roots:
      base:
        - /srv/salt
    gitfs_remotes:
      - https://github.com/accumulo/accumulo-saltstack.git
      - https://github.com/saltstack-formulas/ntp-formula.git
      - https://github.com/accumulo/accumulo-demo-formula.git
      - https://github.com/accumulo/accumulo-formula.git
      - https://github.com/accumulo/zookeeper-formula.git
      - https://github.com/accumulo/hadoop-formula.git
      - https://github.com/accumulo/sun-java-formula.git
      - https://github.com/accumulo/mvn-formula.git
    ext_pillar:
      - git: master https://github.com/accumulo/accumulo-saltstack-pillar.git

If using __make_master__ in the salt-cloud map, this goes into the provider definition (pls also see the salt-cloud documentation for clarification).

In either case it is important that the master has the pip packages __gitdb__ and __GitPython__ installed; these are
necessary for the gitfs remotes to work.

Configuration example:
-

This example is to illustrate the complete setup for a accumulo cluster in ec2 using a salt-cloud map.
Please also note that only versions >= 0.8.9 of salt-cloud support the use of VPC subnets as shown below.

__`/etc/salt/cloud`__

    my-amz:
      provider: ec2
      minion:
        mine_functions:
          network.interfaces: []
          network.ip_addrs: []
          test.ping: []
          grains.items: []
        mine_interval: 2
      ssh_interface: private_ips
      id: ABCDEFG123YOURID
      key: '1234567890yourkey'
      private_key: /etc/salt/your-keyfile.pem
      keyname: your-keyname
      securitygroupid:
        - sg-wrf8w8wf
        - sg-cc77fssfc
      subnetid: subnet-123456789
      del_root_vol_on_destroy: True
      del_all_vols_on_destroy: True
      location: us-east-1
      availability_zone: us-east-1a
      ssh_username: ec2-user

__`/etc/salt/cloud.profiles`__

    my-accumulo-slave:
      provider: my-amz
      image: ami-12345abc
      size: m1.large
      display_ssh_output: False
      make_master: False
      sync_after_install: all
      grains:
        roles:
          - hadoop_slave
          - accumulo_slave
        hdfs_data_disks:
          - /data1
          - /data2
    
    my-accumulo-saltmaster:
      provider: my-amz
      image: ami-12345abc
      size: m1.large
      display_ssh_output: False
      make_master: True
      sync_after_install: all
      grains:
        roles:
          - hadoop_master
          - accumulo_master
        hdfs_data_disks:
          - /data1
      master:
        user: root
        log_level: info
        peer:
          .*:
            - test.*
            - grains.*
        fileserver_backend:
          - roots
          - git
        file_roots:
          base:
            - /srv/salt
        gitfs_remotes:
          - https://github.com/accumulo/accumulo-saltstack.git
          - https://github.com/saltstack-formulas/ntp-formula.git
          - https://github.com/accumulo/accumulo-demo-formula.git
          - https://github.com/accumulo/accumulo-formula.git
          - https://github.com/accumulo/zookeeper-formula.git
          - https://github.com/accumulo/hadoop-formula.git
          - https://github.com/accumulo/sun-java-formula.git
          - https://github.com/accumulo/mvn-formula.git
        ext_pillar:
          - git: master https://github.com/accumulo/accumulo-saltstack-pillar.git

Please note that the minion ids in the map example below are in fqdn format - this is also what their ec2 hostnames end up being set to.

__`/etc/salt/accumulo-demo.map`__

    my-accumulo-saltmaster:
      - systest-master.accumulo-ec2-test.com
    my-accumulo-slave:
      - systest-slave-01.accumulo-ec2-test.com
      - systest-slave-02.accumulo-ec2-test.com
      - systest-slave-03.accumulo-ec2-test.com


__`TODO`__

- add block devices, format and make them available to hadoop
- find a sufficient workaround for the gitfs refresh problems (see https://github.com/saltstack/salt/issues/8026)
