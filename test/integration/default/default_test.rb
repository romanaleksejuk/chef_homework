%w[node_exporter cadvisor].each do |u|
    describe user(u) do
      it { should exist }
    end
  end