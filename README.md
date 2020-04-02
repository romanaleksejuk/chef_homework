# SRE homework

Write a Chef cookbook which

- installs and configures Docker server
- installs and configures Node exporter
- installs and configures Cadvisor
- installs and configures Prometheus as a docker container
- Prometheus should scrape metrics from
  - local Node exporter
  - local Cadvisor
- installs and configures Grafana as Docker container
- Grafana should use Prometheus as a source and provide dashboards for Node exporter and Cadvisor

Requirements: Cookbook should be kitchen testable. Use CentOS 7 for OS.

