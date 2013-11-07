accumulo-saltstack
=

Apache Accumulo integration for SaltStack cluster management tools (https://github.com/saltstack)

NOTE what follows is incomplete but lays out the direction this project is headed.

This is a salt project that will configure a salt master for launching an accumulo cluster in 
a cloud like AWS and Openstack. It can alternatively be used with the Vagrantfile and bootstrap
code provided for local development and testing. 

Salt Master Configuration
-

As this preject has next to no code of its own, you'll need to configure your salt master to pull in the necessary formulas. Also notice that the generic pillar settings are pulled in as ext_pillar via gitfs - you can easily plug in your own settings instead.

Here is an example for now:

    log_level: info
     
    fileserver_backend:
      - roots
      - git
     
    file_roots:
      base:
        - /srv/salt
     
    gitfs_remotes:
      - https://github.com/saltstack-formulas/ntp-formula.git
      - https://github.com/saltstack-formulas/hosts-formula.git
      - https://github.com/accumulo/accumulo-formula.git
      - https://github.com/accumulo/zookeeper-formula.git
      - https://github.com/accumulo/hadoop-formula.git
      - https://github.com/accumulo/sun-java-formula.git
      - https://github.com/accumulo/mvn-formula.git
    
    ext_pillar:
      - git: master https://github.com/accumulo/accumulo-saltstack-pillar.git

Using salt-cloud
-
Clusters will be launched with salt-cloud with commands like the following:

 salt-cloud -m /path/to/mapfile -P

https://salt-cloud.readthedocs.org/en/latest/topics/map.html

The map file is used to select the size of the cluster and the profiles of machines in
the cluster. 

    amazon:
        - ac1:
            minion:
                log_level: debug
                retry_dns: 5
          make_master: True
            grains:
                role: hadoop_master 
                role: accumulo_master 
        - ac2:
            grains:
                role: hadoop_slave 
                role: accumulo_slave 
        - ac3:
            grains:
                role: hadoop_slave 
                role: accumulo_slave 


The machine profiles are defined in files in the cloud.profiles.d directory.  Recent 
versions of salt support launching spot instances which can be configured with a maximum
spot market price.  So launching a (temporary) powerful cluster for development
purposes can be done very cheaply.

    amazon:
        provider: ec2-us-east-public-ips
        image: ami-570f603e
        size: Large Instance 
        ssh-user: ec2-user 
        spot_config: {
           spot_price: 0.09
        }

Using Vagrant
-

The default number of nodes with the Vagrant file is currently 0 - you get one hadoop_master and slave in a standalone configuration.
Bring up the VMs with  `vagrant up`. There is currently no automated provisioning with Vagrant - you will have to login to the salt master (known to vagrant as namenode) with `vagrant ssh namenode` and (as root) run `salt '*' state.highstate`.
This entire mode of operation is for development only - if you are unfamiliar with Vagrant environments this is likely to be a challenge.
