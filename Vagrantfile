Vagrant.configure("2") do |config|
  project_home     = File.expand_path(File.join(File.dirname(__FILE__)))
  states           = project_home
  pillar           = File.join(project_home, "pillar")
  download_folder  = File.join(project_home, "downloads")
  dev_formulas     = File.join(project_home, '..', 'formulas')
  dot_m2_folder    = File.join(Dir.home, '.m2', 'repository')
  m2_folder        = dot_m2_folder if FileTest.directory?(dot_m2_folder)
  Dir.mkdir(pillar) unless FileTest.directory?(pillar)
  Dir.mkdir(download_folder) unless FileTest.directory?(download_folder)
  clusterdomain    = "accumulo.local"
  datanode_count   = ENV['NODE_COUNT'] || '0'
  supported_dists  = %w{asf2 asf1 hdp1 hdp2 cdh4-mr cdh4-yarn}
  hadoop_dist_raw  = ENV['HADOOP_DIST'] || 'asf2'
  is_singlenode    = datanode_count.eql?('0')
  vmname_prefix    = ENV['VMNAME_PREFIX'] || 'accumulo-salt'
  os               = ENV['VIRT_OS'] || 'centos'
  
  if supported_dists.include?(hadoop_dist_raw)
    hadoop_dist = hadoop_dist_raw
  else
    raise ArgumentError, "HADOOP_DIST #{hadoop_dist_raw} is unsupported - use one of #{supported_dists.join(',')}"
  end

  logging_env      = ENV['logging'].to_s
  logging          = "--#{logging_env}" if %w{verbose debug}.include?(logging_env)

  if is_singlenode
    datanode_list    = ["namenode"]
    node_list        = ["namenode"]
  else
    datanode_list    = "1".upto(datanode_count).collect {|c| "dnode#{c}"}
    node_list        = datanode_list + ["namenode"]
  end

  host_list = {}
  node_list.each do |hostname|
    if hostname.eql?("namenode")
      host_list[hostname] = "192.169.111.111"
    else
      host_list[hostname] = "192.169.111.10#{hostname[-1]}"
    end
  end

  config.vm.synced_folder m2_folder, "/mavenrepo" unless m2_folder.nil?
  config.vm.synced_folder states, "/srv/salt"
  config.vm.synced_folder pillar, "/srv/pillar"

  # if <name>-formula is found in ../formulas they will be mounted 
  # as /srv/<name>-formula

  if FileTest.directory?(dev_formulas)
    Dir.glob("#{dev_formulas}/*-formula") do |d|
      config.vm.synced_folder d, "/srv/#{File.basename(d)}"
    end
  end
  
  config.vm.synced_folder download_folder, "/downloads"
  if os.eql?('ubuntu')
    config.vm.box_url = "http://sroegner-vagrant.s3.amazonaws.com/ubuntu-salt.box"
    config.vm.box = "ubuntu_node_salt"
  else
    config.vm.box_url = "http://sroegner-vagrant.s3.amazonaws.com/centos6min-salt.box"
    config.vm.box = "centos6_node_salt"
  end
  config.vm.provision :shell, :path => 'vagrant-bootstrap/bs.sh', :args => "#{datanode_count} #{os}"

  node_list.each do |nodename|
    config.vm.define nodename do |n|
      n.vm.hostname = "#{nodename}.#{clusterdomain}"
      n.vm.network :private_network, ip:"#{host_list[nodename]}", :adapter => 2
      n.vm.provider "virtualbox" do |v|
        if nodename.eql?("namenode")
          v.customize [ 'modifyvm', :id, '--name', "#{vmname_prefix}-#{nodename}", '--memory', "3072", '--cpus', "1" ]
        else
          v.customize [ 'modifyvm', :id, '--name', "#{vmname_prefix}-#{nodename}", '--memory', "2048", '--cpus', "1" ]
        end
      end
    end
  end


end

