RAILS_GEM_VERSION = '2.1.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')



Rails::Initializer.run do |config|
  config.frameworks -= [ :active_record, :active_resource, :action_mailer ]
  config.time_zone = 'UTC'
  config.action_controller.session = :off  
end

# require 'new_routes_mapper'
