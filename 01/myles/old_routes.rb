ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'menus', :action => 'fa_coffee', :conditions => { :method => :get }

  map.connect 'tests/:action', :controller => 'tests'

  map.connect 'user.js', :controller => 'users', :action => 'find_or_create', 
    :conditions => { :method => :get }

  map.connect ':slug/order', :controller => 'orders', :action => 'update', 
    :conditions => { :method => :put }
  map.connect ':slug/order', :controller => 'orders', :action => 'show', 
    :conditions => { :method => :get }
  map.connect ':slug/item_images/*image', :controller => 'item_images', :action => 'show'


end

