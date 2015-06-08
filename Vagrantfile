Vagrant.configure("2") do |config|
  project_home     = File.expand_path(File.join(File.dirname(__FILE__)))
  states           = project_home
  pillar           = File.join(project_home, "pillar")
  dev_formulas     = File.join(project_home, '..', 'formulas')
  dot_m2_folder    = File.join(Dir.home, '.m2', 'repository')
  m2_folder        = dot_m2_folder if FileTest.directory?(dot_m2_folder)
  Dir.mkdir(pillar) unless FileTest.directory?(pillar)
  clusterdomain    = "accumulo.local"
  datanode_count   = ENV['NODE_COUNT'] || '0'
  vmname_prefix    = ENV['VMNAME_PREFIX'] || 'accumulo-salt'
  os               = 'centos'
  is_singlenode    = datanode_count.eql?('0')
  node_list        = "1".upto(datanode_count).collect {|c| "dnode#{c}"} + ["namenode"]

  config.vm.synced_folder m2_folder, "/mavenrepo" unless m2_folder.nil?
  config.vm.synced_folder states, "/srv/salt"
  config.vm.synced_folder pillar, "/srv/pillar"

  # if <name>-formula is found in ../formulas they will be mounted
  # as /srv/<name>-formula
  # the VM will 'switch' into development mode which means you'll have no gitfs remote formulas
  if FileTest.directory?(dev_formulas)
    Dir.glob("#{dev_formulas}/*-formula") do |d|
      config.vm.synced_folder d, "/srv/#{File.basename(d)}"
    end
  end

  config.vm.box_url = "https://s3.amazonaws.com/sroegner-vagrant/salt-latest.box"
  config.vm.box = "salt-accumulo"

  node_list.each_with_index do |nodename, idx|
    fqdn = "#{nodename}.#{clusterdomain}"
    ip = nodename.eql?('namenode') ? '192.169.111.211' : "192.169.111.20#{idx}"
    config.vm.define nodename do |n|
      n.vm.network :private_network, ip:"#{ip}", :adapter => 2
      n.vm.provider "virtualbox" do |v, override|
        override.vm.provision :shell, :path => 'vagrant-bootstrap/bs.sh', :args => "#{datanode_count} #{os} #{fqdn}"
        if nodename.eql?("namenode")
          if is_singlenode
            v.customize [ 'modifyvm', :id, '--name', "#{vmname_prefix}-#{nodename}", '--memory', "6144", '--cpus', "2" ]
          else
            v.customize [ 'modifyvm', :id, '--name', "#{vmname_prefix}-#{nodename}", '--memory', "3072", '--cpus', "2" ]
          end
        else
          v.customize [ 'modifyvm', :id, '--name', "#{vmname_prefix}-#{nodename}", '--memory', "2048", '--cpus', "1" ]
        end
      end
    end
  end

end


