require "rubygems"
require "spec"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

module FancyRoutes
  class Route
    
    attr_accessor :request_method
    
    def get
      self.request_method(:get)
      self
    end
    
  end
end

describe "FancyRoutes" do
  
  example "route on root" do
    @map = FancyRoutes::Route.new
    
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action'
    })
    # @fancyroutes.get /'' >> :my_controller > :my_action
    
  end  
end




