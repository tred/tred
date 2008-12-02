## harness

class RequestStub
  
  PROPS = [:method, :path]
  attr_accessor *PROPS
  
  def self.build(props = {})
    new.tap do |rs| 
      PROPS.each { |name| rs.send("#{name}=", props[name]) } 
    end
  end
  
  alias_method :request_method, :method
  
  def to_s
    "#{method.to_s.upcase} #{path}"
  end
  
end

class RouteTester
  
  def initialize(route)
    @route = route
  end
  
  def test(&blk)
    puts "\nRoute: #{@route.to_s}"
    instance_eval &blk
  end
  
  # shorthand for mock get request
  def get(path)
    RequestStub.build :method => :get, :path => path
  end
  
  def post(path)
    RequestStub.build :method => :post, :path => path
  end
  
  # def assert_success
  #   
  # end
  
  def matches(request, expected_params)
    route = @route.dup
    if expected_params == route.match(request)
      puts "  #{request} => " + "successfully matched".green
    else
      puts "  #{request} => " + "failed to match (got: #{route.matched_params.inspect})".red
    end
  end
  
  alias_method :MATCH, :matches
  
  def fails(*requests)
    route = @route.dup
    requests.each do |request|
      if !route.match(request)
        puts "  #{request} => " + "successfully didn't match".green
      else
        puts "  #{request} => " + "matched when it shouldn't have".red
      end
    end
  end
  
  alias_method :FAILS, :fails
  
end

class RoutesTester < RouteTester
  
  def initialize(router)
    @router = router
  end
  
  def test(&blk)
    puts "\nRouter with #{@router.matchers.size} routes:"
    puts @router.matchers
    puts
    instance_eval &blk
  end
  
  def matches(request, expected_params)
    if expected_params == @router.recognize_params(request)
      puts "  #{request} => " + "successfully matched".green
    else
      puts "  #{request} => " + "failed to match".red
    end
  end
  
  alias_method :MATCH, :matches
  
  def fails(*requests)
    requests.each do |request|
      if !@router.recognize_params(request)
        puts "  #{request} => " + "successfully didn't match".green
      else
        puts "  #{request} => " + "matched when it shouldn't have".red
      end
    end
  end
  
  alias_method :FAILS, :fails
  
end

# final pieces

class RequestMatcher
  
  def test(&blk)
    RouteTester.new(self).test(&blk)
  end
  
  def to_s
    "#{(self.method || '?').to_s.rjust(4)} #{self.segments.join(' / ').ljust(30)} #{controller || '?'} #{action || '?'}"
  end
    
end

class NewRouteMapper
  
  def test(&blk)
    RoutesTester.new(self).test(&blk)
  end
  
end

def new_route
  RequestMatcher.new
end

def new_routes(&blk)
  nrm = NewRouteMapper.new.tap{ |nrm| nrm.setup(&blk) }
end
