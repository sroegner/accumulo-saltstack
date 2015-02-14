echo "Calling the provisioning script inside vagrant now - this will take a while and there will be no output for some time"

vagrant ssh namenode -c /vagrant/vagrant-bootstrap/orchestrate.sh

