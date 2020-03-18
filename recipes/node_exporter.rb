#
# Cookbook:: base-wrappper
# Recipe:: node_exporter
#
# Copyright:: 2020, Roman Aleksejuk, All Rights Reserved.

user "node_exporter" do
  comment "prometheus node_exporter user"
  system true
  shell "/bin/false"
end

group "node_exporter"

group "node_exporter" do
  members "node_exporter"
end

remote_file "/tmp/#{node['node_exporter']['file_name']}.tar.gz" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  source node['node_exporter']['download_url']
end

directory "/tmp/#{node['node_exporter']['file_name']}"

execute "tar xvf /tmp/#{node['node_exporter']['file_name']}.tar.gz -C /tmp" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  command "tar xvf /tmp/#{node['node_exporter']['file_name']}.tar.gz -C /tmp"
end


ruby_block "cp /tmp/#{node['node_exporter']['file_name']}/node_exporter /usr/local/bin" do
  not_if { ::File.exist?('/usr/local/bin/node_exporter') }
  block do
    require 'fileutils'
    FileUtils.cp "/tmp/#{node['node_exporter']['file_name']}/node_exporter", '/usr/local/bin/'
  end
end

file '/usr/local/bin/node_exporter' do
  owner 'node_exporter'
  group 'node_exporter'
  notifies :restart, "service[node_exporter]"
end

systemd_unit 'node_exporter.service' do
  content <<-EOU.gsub(/^\s+/, '')
  [Unit]
  Description=Node Exporter
  Wants=network-online.target
  After=network-online.target
  [Service]
  User=node_exporter
  Group=node_exporter
  Type=simple
  ExecStart=/usr/local/bin/node_exporter --web.listen-address=#{node['ipaddress']}:9100 \
     --web.telemetry-path=/metrics \
      --log.level=info \
      --log.format=logger:stdout \
      --collector.textfile.directory=/var/lib/node_exporter/textfile_collector \
      --collector.netdev.ignored-devices='^(weave|veth.*|docker0|datapath|dummy0)$' \
      --collector.filesystem.ignored-mount-points='^/(sys|proc|dev|host|etc|var/lib/docker|run|var/lib/lxcfs|var/lib/kubelet)($|/)' \
      --collector.diskstats \
      --collector.filefd \
      --collector.filesystem \
      --collector.interrupts \
      --collector.loadavg \
      --collector.mdadm \
      --collector.meminfo \
      --collector.netdev \
      --collector.netstat \
      --collector.sockstat \
      --collector.stat \
      --collector.tcpstat \
      --collector.textfile \
      --collector.time \
      --collector.uname \
      --collector.vmstat
  [Install]
  WantedBy=multi-user.target
  EOU
  verify false
  action [:create, :enable, :start]

end

service 'node_exporter' do
  restart_command "systemctl restart node_exporter"
  action :nothing
end