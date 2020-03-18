#
# Cookbook:: base-wrappper
# Recipe:: grafana
#
# Copyright:: 2020, Roman Aleksejuk, All Rights Reserved.

execute 'grafana-restart' do
    command 'docker restart grafana'
    action :nothing
  end
  
directory '/etc/grafana/provisioning/datasources' do
    recursive true
    mode '0755'
    action :create
end
  
directory '/etc/grafana/provisioning/dashboards' do
    mode '0755'
    action :create
end
  
directory '/var/lib/grafana/dashboards' do
    recursive true
    mode '0755'
    action :create
end
  
template '/etc/grafana/provisioning/datasources/datasource.yaml' do
    source 'grafana/datasource.erb'
    mode '0755'
    notifies :run, 'execute[grafana-restart]', :delayed
end
  
template '/etc/grafana/provisioning/dashboards/dashboards.yaml' do
    source 'grafana/dashboards.erb'
    mode '0755'
    notifies :run, 'execute[grafana-restart]', :delayed
end
  
  
  
cookbook_file '/var/lib/grafana/dashboards/cadvisor.json' do
    source 'grafana/cadvisor.json'
    mode '0755'
    action :create
    notifies :run, 'execute[grafana-restart]', :delayed
end
  
cookbook_file '/var/lib/grafana/dashboards/node-exporter.json' do
    source 'grafana/node-exporter.json'
    mode '0755'
    action :create
    notifies :run, 'execute[grafana-restart]', :delayed
end
  
docker_image 'grafana' do
    repo 'grafana/grafana'
    tag node['grafana']['version']
    action :pull
end
  
docker_container 'grafana' do
    repo 'grafana/grafana'
    tag node['grafana']['version']
    action :run_if_missing
    restart_policy 'always'
    network_mode 'net1'
    port '3000:3000'
    env ['GF_SECURITY_ADMIN_PASSWORD=secret'] 
    volumes ['/etc/grafana/provisioning:/etc/grafana/provisioning','/var/lib/grafana/dashboards:/var/lib/grafana/dashboards']
end