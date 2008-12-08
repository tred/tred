require "rubygems"
require "spec"

Spec::Runner.configure do |config|
  config.mock_with :rr
end

module FancyRoutes
  class Route
    
    def initialize(map)
      @map = map
      @segments = []
    end

    def request_method(method)
      @request_method = method.to_s
      self
    end
    
    def segment(path_segment)
      @segments << path_segment
      self
    end
    alias_method :/, :segment
    
    def controller(controller_name)
      @controller = controller_name.to_s
      self
    end
    alias_method :>>, :controller
    
    def action(action_name)
      @action = action_name.to_s
      self
    end
    alias_method :>, :action
    
    def get
      request_method(:get)
      self
    end
        
    def create
      @map.connect(segments, 
        :controller => @controller,
        :action => @action,
        :conditions => { :method => @request_method }
      )
    end
    
    
    protected
    
    def segments
      @segments.join '/'
    end
     
  end
end

describe "FancyRoutes" do
  before(:each) do
    @map = Object.new
    @fancyroutes = FancyRoutes::Route.new(@map)
  end

  example "route on root" do
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => 'get' },
    })
    
    @fancyroutes.request_method(:get).segment('').controller(:my_controller).action(:my_action).create
  end  

  example "short form route on root" do
    mock(@map).connect('', {
      :controller => 'my_controller',
      :action => 'my_action',
      :conditions => { :method => 'get' },
    })
    
    (@fancyroutes.get / '' >> :my_controller > :my_action).create
  end  


end




