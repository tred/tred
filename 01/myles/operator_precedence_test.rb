class Chain
  
  def initialize
    @segments = []
  end
  
  def /(segment)
    @segments << segment.to_s
    self
  end
  
  def >>(controller)
    @controller = controller
    self
  end
  
  def >(action)
    @action = action
    puts "segments: #{@segments.join(',')}; controller: #{@controller}, action: #{@action}"
  end
  
  def map(&blk)
    puts blk.call(self)
  end
  
end

map = Chain.new

map/'seg1'/:seg2/'seg3' >> :my_controller > :my_action

(map/'somepath').map do |somepath| 
  'bla'
end