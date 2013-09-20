#
# Cookbook Name:: teamcity_build_agent
# Recipe:: default
#

include_recipe "appbox"
include_recipe "java"

archive_directory = Chef::Config[:file_cache_path]
zip_name = "TeamCity-BuildAgent-#{node["teamcity_build_agent"]["version"]}.zip"
zip_dest = "#{archive_directory}/#{zip_name}"
zip_source = node['teamcity_build_agent']['address'] + "/update/buildAgent.zip"
install_dir = "/opt/teamcity/buildAgent"

# Download the build agent from the teamcity server
remote_file zip_dest do
  source zip_source
  action :create_if_missing
end

# Remove the installation directory
directory install_dir do
  action :delete
  recursive true
end

# Create the installation directory
directory install_dir do
  mode "0755"
  action :create
end

# Unzip the build agent into the installation directory
bash "unzip-buildAgent" do
  code <<-EOH
    unzip #{zip_dest} -d #{install_dir}
  EOH
end

# Change the file permissions on the shell script in the installation directory
file install_dir + "/bin/install.sh" do
  action :touch
  mode 00755
end

# Run the installation
bash "install-buildAgent" do
  cwd install_dir + "/bin"
  code <<-EOH
    ./install.sh #{node['teamcity_build_agent']['address']}
  EOH
end

# Change the file permissions on the agent shell script
file install_dir + "/bin/agent.sh" do
  action :touch
  mode 00755
end

# Ensure the agent is running
bash "ensure-buildAgent-running" do
  not_if "pgrep -f buildServer.agent.Launcher"
  cwd install_dir + "/bin"
  code <<-EOH
    export JRE_HOME=/usr
    ./agent.sh start
  EOH
end

# Remove the installation zip
file zip_dest do
  action :delete
end