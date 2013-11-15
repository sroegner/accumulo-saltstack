accumulo-saltstack
=

Apache Accumulo integration for SaltStack cluster management tools (https://github.com/saltstack)

NOTE what follows is incomplete but lays out the direction this project is headed.

This is a working example project that will help you launching an accumulo cluster - usually in
a cloud like AWS and Openstack. It can alternatively be used with the Vagrantfile and bootstrap
code provided for local development and testing. 

All the 'real' provisioning code is pulled into this scaffold as salt formulas using gitfs remote configuration on the master.
With this being the main principle (100% of the code and configuration live in external repositories) the saltmaster
itself can be dynamically provisioned as part of salt-cloud maps, thus providing the ability to run an arbitrary number
of clusters in different of identical topology and configuration in the same (or differnet) cloud provider account(s).

Salt Master Configuration
-

As this project has next to no code of its own, you'll need to configure your salt master to pull in the necessary formulas. Also notice that the generic pillar settings are pulled in as ext_pillar via gitfs - you can easily plug in your own settings instead.
Please see AWS_EXAMPLE.md for a full configuration example.

Using Vagrant
-

The default number of nodes with the Vagrant file is currently 0 - you get one hadoop_master and slave in a standalone configuration.
Bring up the VMs with  `vagrant up`. There is currently no automated provisioning with Vagrant - you will have to login to the salt master (known to vagrant as namenode) with `vagrant ssh namenode` and (as root) run `salt '*' state.highstate`.
This entire mode of operation is for development only - if you are unfamiliar with Vagrant environments this is likely to be a challenge.
