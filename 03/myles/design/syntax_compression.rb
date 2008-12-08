# rails
map.connect ':slug/order', :conditions => { :method => :put }, :controller => 'orders', :action => 'update'

# chained methods on connect ... similar to merb
match.method(:put).segments(':slug/order').to(:controller => 'orders', :action => 'update')

# explicit controller and action methods for setting those
match.method(:put).segments(':slug/order').controller('orders').action('update')

# put just calls match.method(:put)
put.segments(':slug/order').controller(:orders).action(:update)

# split up segments
put.segment(':slug').segment('order').controller(:orders).action(:update)

# ok, ':slug' can just be :slug
put.segment(:slug).segment('order').controller(:orders).action(:update)

# now we can use some operators for the common methods: segment and action
put /:slug/'order' >> :orders > :update

# if a segment matches the name of a controller you can put the controller inline
put /:slug/'items_was_a_long_word' >> :items_was_a_long_word > :update
put /:slug/{'items_was_a_long_word' => :controller} > :update