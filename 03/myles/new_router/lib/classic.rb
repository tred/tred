# classic routes
classic do |map|

  map.connect 'tests/:action', :conditions => { :method => :get }, 
    :controller => 'tests'
  
  map.root :conditions => { :method => :get }, 
    :controller => 'menus', :action => 'fa_coffee'

  map.connect ':slug', :conditions => { :method => :get }, 
    :controller => 'restaurants', :action => 'show'
  
  map.connect ':slug/menu', :conditions => { :method => :get }, 
    :controller => 'menus', :action => 'show'

  map.connect ':slug/order', :conditions => { :method => :put },
    :controller => 'orders', :action => 'update'
  
  map.connect ':slug/order', :conditions => { :method => :get }, 
    :controller => 'orders', :action => 'show'
  
  map.connect ':slug/item_images/*image', :conditions => { :method => :get }, 
    :controller => 'item_images', :action => 'show'
  
end