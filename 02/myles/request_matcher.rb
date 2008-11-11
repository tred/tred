class RequestMatcher

  attr_reader :method, :segments
  
  def self.build(dispatcher,method,segments)
    new(dispatcher,method.to_s,segments)
  end
  
  def initialize(dispatcher, method,segments)
    @dispatcher, @method, @segments = dispatcher, method, segments
  end
  
  def match_names
    @match_names ||= []
  end
  
  def parse_segments
    @parsed_segments = @segments.map do |seg|
      case seg
      when String
        match_names << nil
        /(#{seg})/
      when Symbol
        match_names << seg
        %r{([^/]+)}
      when Hash
        key, val = seg.keys.first, seg.values.first
        if key.is_a?(Regexp) && val.is_a?(Symbol)
          match_names << val
          /(#{key})/
        end
      end
    end
  end
  
  def segments
    @parsed_segments || parse_segments
  end
  
  def exp
    %r[^/#{segments.join('/')}$]
  end
  
  def method_matches?(method)
    method.downcase == @method 
  end

  def match(request)
    return false unless 
      method_matches?(request.request_method) && path_match = exp.match(request.path_info)
    
    named_captures = {}
    path_match.captures.each_with_index do |cap,index|
      match_name = match_names[index]
      named_captures[match_name] = cap if match_name
    end
    @dispatcher.params.merge!(named_captures)
    true
  end
  
  alias_method :===, :match
  
end