accumulo-saltstack
==================

Apache Accumulo integration for SaltStack cluster management tools (https://github.com/saltstack)

NOTE what follows is incomplete but lays out the direction this project is headed.

This is a salt project that will configure a salt master for launching an accumulo cluster in 
a cloud like AWS and Openstack. It can alternatively be used with the Vagrantfile and bootstrap
code provided for local development and testing. 

``Using Vagrant``

The default number of nodes with the Vagrant file is two - you get one hadoop_master and one hadoop_slaves 
(accumulo roles are assigned accordingly).
Bring up the VMs with 
    vagrant up
There is currently no automated provisioning with Vagrant - you will have to login
    vagrant ssh namenode
to the salt master and (as root) run
    salt '*' state.highstate

``Using salt-cloud``
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
            role: master 
            role: zookeeper 
    - ac2:
        minion:
            log_level: warn
        grains:
            role: slave 
            role: zookeeper 
    - ac3:
        minion:
            log_level: warn
        grains:
            role: slave 
            role: zookeeper 


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


