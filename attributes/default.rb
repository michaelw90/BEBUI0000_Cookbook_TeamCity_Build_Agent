default[:teamcity_build_agent][:server_url] = "http://teamcity.localhost"

# A new property added that allows the service to be added as a systemd service instead,
# which seem to be the preferred way in Ubuntu 16.04.
default[:teamcity_build_agent][:systemd] = false
