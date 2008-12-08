# ActionController::Routing::Routes.draw do |map|
#   # map.connect ':controller/:action/:id'
#   # map.connect ':controller/:action/:id.:format'
# end

NewRoutes = NewRouteMapper.new

NewRoutes.setup do
  
  get.root >> :tests > :show
  
  with get/'people' do
    
    match/:name >> :tests > :show
    
  end

  
end