# versions to download

default['node_exporter']['version'] = '0.18.1'
default['node_exporter']['download_url'] = "https://github.com/prometheus/node_exporter/releases/download/v#{default['node_exporter']['version']}/node_exporter-#{default['node_exporter']['version']}.linux-amd64.tar.gz"
default['node_exporter']['file_name'] = "node_exporter-#{default['node_exporter']['version']}.linux-amd64"

default['cadvisor']['version'] = '0.35.0'
default['cadvisor']['download_url'] = "https://github.com/google/cadvisor/releases/download/v#{default['cadvisor']['version']}/cadvisor"
default['cadvisor']['file_name'] = "cadvisor"

default['grafana']['version'] = '6.6.2'

default['prometheus']['version'] = '2.16.0'