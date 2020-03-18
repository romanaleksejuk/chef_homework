describe port(3000) do
  it { should be_listening }
end

describe command('curl -XGET -s http://127.0.0.1:3000/api/health') do
  its('stdout') { should match (/.*ok.*/) }
end

describe docker_container('grafana') do
  it { should exist }
  it { should be_running }
  its('ports') { should eq '0.0.0.0:3000->3000/tcp' }
end

describe http('http://127.0.0.1:3000/api/datasources',
              auth: { user: 'admin', pass: 'secret' },
              method: 'GET') do
  its('status') { should cmp 200 }
  its('headers.Content-Type') { should cmp 'application/json' }
end

describe http('http://127.0.0.1:3000/api/search',
              auth: { user: 'admin', pass: 'secret' },
              method: 'GET') do
  its('status') { should cmp 200 }
  its('body') { should match %r{db\/cadvisor} }
  its('body') { should match %r{db\/node-exporter} }
  its('headers.Content-Type') { should cmp 'application/json' }
end
