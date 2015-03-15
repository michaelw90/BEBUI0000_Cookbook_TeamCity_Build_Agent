#
# Cookbook Name:: cookbook_teamcity_build_agent
# Recipe:: service
#

# Set the useful variables for the recipe
agent_path = "/opt/teamcity/buildAgent"


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