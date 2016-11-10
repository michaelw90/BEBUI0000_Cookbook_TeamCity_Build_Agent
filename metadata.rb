name             'teamcity_build_agent'
maintainer       'Fred Thompson'
maintainer_email 'fred.thompson@buildempire.co.uk'
license          'Apache 2.0'
description      'TeamCity Build Agent.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.8'

recipe 'teamcity_build_agent', 'TeamCity Build Agent.'

%w{ ubuntu }.each do |os|
  supports os
end

%w{build-essential appbox java}.each do |cb|
  depends cb
end