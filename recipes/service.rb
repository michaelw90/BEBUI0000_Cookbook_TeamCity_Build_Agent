#
# Cookbook Name:: cookbook_teamcity_build_agent
# Recipe:: service
#

# Set the useful variables for the recipe
agent_path = "/opt/teamcity/buildAgent"

if node[:teamcity_build_agent][:systemd]
  # Create TeamCity Service as systemd
  systemd_unit "teamcity-build-agent.service" do
    enabled true
    active true
    content "[Unit]\nDescription=TeamCity Build Agent\nAfter=network.target\n\n[Service]\nType=forking\nPIDFile=%{agent_path}/logs/buildAgent.pid\nExecStart=/usr/bin/sudo -u teamcity %{agent_path}/bin/agent.sh start\nExecStop=/usr/bin/sudo -u teamcity %{agent_path}/bin/agent.sh stop\n\nRestart=always\n[Install]\nWantedBy=multi-user.target"
    action [:create, :enable, :start]
  end
else
  # Create TeamCity Service
  template '/etc/init/teamcity-build-agent.conf' do
    source 'teamcity-build-agent.conf.erb'
    variables(
      :agent_path => agent_path
    )
    notifies :start, 'service[teamcity-build-agent]', :immediately
  end
  # Start TeamCity Service
  service "teamcity-build-agent" do
    provider Chef::Provider::Service::Upstart
    action :restart
  end
end