class NewRouteMapper
  
  def draw(&blk)
    
  end
  
  def recognize(request)
    request.path_parameters = { :controller => 'tests', :action => 'show' }
    TestsController
  end
  
end

NewRoutes = NewRouteMapper.new

# monkey patch
module ActionController::Routing
  
  def Routes.recognize(request)
    NewRoutes.recognize(request)
  end
  
end