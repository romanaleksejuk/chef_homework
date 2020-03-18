#
# Cookbook:: base-wrappper
# Recipe:: cadvisor
#
# Copyright:: 2020, Roman Aleksejuk, All Rights Reserved.


remote_file "/usr/local/bin/cadvisor" do
  source node['cadvisor']['download_url']
  mode '0755'
  action :create_if_missing
end

user 'cadvisor' do
    comment 'cadvisor user'
    system true
    shell '/bin/false'
end

#group 'docker' do
#    action :manage
#    members 'cadvisor'
#end

file '/usr/local/bin/cadvisor' do
    # owner 'cadvisor'
    # group 'cadvisor'
    notifies :restart, "service[cadvisor]", :delayed
end

systemd_unit 'cadvisor.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Analyzes resource usage and performance characteristics of running containers
  After=local-fs.target network-online.target network.target
  Wants=local-fs.target network-online.target network.target
  
  [Service]
  ExecStart=/usr/local/bin/#{node['cadvisor']['file_name']}
  Type=simple
  Restart=on-failure
  

  [Install]
  WantedBy=multi-user.target  
  EOU
action [ :create, :enable, :start]
verify false
notifies :restart, "service[cadvisor]", :delayed
end

service 'cadvisor' do
    restart_command "systemctl restart cadvisor"
    action :nothing
end