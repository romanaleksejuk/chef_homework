#
# Cookbook:: base-wrappper
# Recipe:: prometheus
#
# Copyright:: 2020, Roman Aleksejuk, All Rights Reserved.

docker_image "prometheus" do
    repo 'prom/prometheus'
    tag "v#{node['prometheus']['version']}"
    action :pull
  end
  
docker_container 'prometheus' do
    repo 'prom/prometheus'
    tag "v#{node['prometheus']['version']}"
    action :run_if_missing
    restart_policy 'always'
    network_mode 'net1'
    port '9090:9090'
    volumes [ '/etc/prometheus/:/etc/prometheus/' ]
end
  
execute 'prometheus-restart' do
    command 'docker restart prometheus'
    action :nothing
end
  
directory '/etc/prometheus' do
    mode '0755'
    action :create
end
  
template '/etc/prometheus/prometheus.yml' do
    source 'prometheus/prometheus.erb'
    mode '0755'
    notifies :run, 'execute[prometheus-restart]', :delayed
end