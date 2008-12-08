# a standard refactor (thanks Nathan)
refactored do |map|
  GET = { :method => :get }
  PUT = { :method => :put }
  
  map.connect 'tests/:action', :conditions => GET, :controller => 'tests'
  map.root :conditions => GET, :controller => 'menus', :action => 'fa_coffee'

  with_options(:path_prefix => ':slug') do |slug|
    
    slug.connect '', :conditions => GET, :controller => 'restaurants', :action => 'show'
    slug.connect 'menu', :conditions => PUT, :controller => 'menus', :action => 'show'

    with_options(:controller => 'orders') do |orders|
      orders.connect 'order', :conditions => PUT, :action => 'update'
      orders.connect 'order', :conditions => GET, :action => 'show'
    end
  
    slug.connect 'item_images/*image', :conditions => GET, :controller => 'item_images', :action => 'show'
  end
  
end