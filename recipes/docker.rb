#
# Cookbook:: base-wrappper
# Recipe:: docker
#
# Copyright:: 2020, Roman Aleksejuk, All Rights Reserved.

docker_service 'default' do
    install_method 'auto'
    service_manager 'auto'
    action [:create, :start]
end

docker_network 'net1' do
  action :create
end