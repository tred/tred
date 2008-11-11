map.connect ':slug/order', :controller => 'orders', :action => 'update', :conditions => { :method => :put }
  
map.get ':slug/order', :controller => 'orders', :action => 'update'

map.get(':slug/order').controller('orders').action('update')

map.get(':slug/order').controller(:orders).action(:update)

map.get(:slug,'order').controller(:orders).action(:update)

map.get(:slug,'order') >> :orders > :update

map.get.segment(:slug).segment('order') >> :orders > :update

map.get/:slug/'orders' >> :orders > :update

map.get/:slug/('orders'=>:controller) > :update


