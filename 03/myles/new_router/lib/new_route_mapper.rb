## support

class Object
  def tap
    yield(self) ; self
  end
end

class RequestMatcher

  # jquery style, getters/setters/chaining

  def initialize
    @segments = []
  end

  # set the request method
  def method(name = nil)
    return @method unless name
    @method = name
    self
  end
  
  def get; method(:get) end
  def post; method(:post) end
  
  # a segment of the url
  def segment(seg)
    @segments << seg
    self
  end
  
  alias_method :/, :segment
  
  def root; segment('') end
    
  # the controller to route to
  def controller(name = nil)
    return @controller unless name
    @controller = name.to_s
    self
  end
  
  alias_method :>>, :controller
  
  # the action to route to
  def action(name = nil)
    return @action unless name
    @action = name.to_s
    self
  end
  
  alias_method :>, :action
  
  # these are all called by router
  
  def match(request)
    return unless 
      request.request_method == @method  &&
      request.path =~ Regexp.new(exp)
    
    $~.captures.each_with_index do |cap,index|
      match_name = match_names[index]
      path_params[match_name] = cap if match_name
    end
    matched_params
  end
  
  def parse_segments
    @parsed_segments = @segments.map do |seg|
      case seg
      when String
        match_names << nil
        "(#{seg})"
      when Symbol
        match_names << seg
        "([^/]+)"
      when Hash
        key, val = seg.keys.first, seg.values.first
        if key.is_a?(Regexp) || key.is_a?(String) && val.is_a?(Symbol)
          match_names << val
          "(#{key})"
        end
      end
    end
  end
  
  def segments
    @parsed_segments || parse_segments
  end
  
  def matched_params
    path_params.tap do |pp|
      pp[:controller] = @controller if @controller
      pp[:action] = @action if @action
    end
  end
  
  def path_params
    @path_params ||= {}
  end
  
  def match_names
    @matched_names ||= []
  end
  
  def exp
    "^/#{segments.join('/')}$"
  end
  
  def copy
    new_segments = @segments.dup
    dup.tap { |copy| 
      copy.instance_eval { @segments = new_segments; @path_params = nil }
    }
  end
  
end

class NewRouteMapper
    
  def setup(&blk)
    matchers = [] # clear old matchers
    instance_eval &blk
  end
  
  def add_matcher
    rmatcher = RequestMatcher.new
    matchers << rmatcher # probably need to pass self here
    rmatcher
  end
  
  alias_method :match, :add_matcher
  
  def get ; add_matcher.get end
  def post; add_matcher.post end
  
  class NestedContext
    
    def initialize(parent, matcher)
      @parent, @matcher = parent, matcher 
    end
    
    def matchers
      @parent.matchers
    end
    
    def add_matcher
      new_matcher = @matcher.copy
      matchers << new_matcher
      new_matcher
    end
    
    def with(matcher,&blk); @parent.with(matcher,&blk) end
    
    alias_method :match, :add_matcher
    
    def get ; add_matcher.get end
    def post; add_matcher.post end
      
  end
  
  def with(matcher, &blk)
    NestedContext.new(self,matcher).instance_eval &blk
  end
  
  # super nieve
  def recognize_params(request)
    match = nil
    # reverse?
    matchers.detect { |rmatcher| match = rmatcher.match(request) }
    match
  end
  
  # rails api
  def recognize(request)
    raise ActionController::RoutingError, "No route matches #{request.path.inspect}" unless params = recognize_params(request)
    
    request.path_parameters = params.with_indifferent_access
    "#{params[:controller].camelize}Controller".constantize
  end
  
  def matchers
    # we could ignore matchers that don't have method constraints as they'll never match
    @patterns ||= []
  end
  
end

if Object.const_defined? :ActionController
  module ActionController::Routing
  
    def Routes.recognize(request)
      NewRoutes.recognize(request)
    end
  
  end
end