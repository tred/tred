require 'rubygems'
require 'colored'

require 'new_route_mapper'
require 'new_routes_test_harness'

#system "clear"

## tests

# long format, equivalent to: new_route.get.root >> :my_controller > :my_action
new_route.method(:get).segment('').controller(:my_controller).action(:my_action).
test do
  MATCH get('/'), 
    { :controller => 'my_controller', :action => 'my_action' }
  
  FAILS get('/foo'), post('')
end

# shorter
new_route.get.root.controller(:my_controller).action(:my_action).
test do
  MATCH get('/'), 
    { :controller => 'my_controller', :action => 'my_action' }
end

# short_form, also: regex
( new_route.get/{/.+/ => :set}/:book_id >> :my_controller > :show ).
test do
  MATCH get('/tags/22'),
    { :book_id => '22', :set => 'tags',
      :controller => 'my_controller', :action => 'show' }
  
  FAILS get('/tags')  
end

# inline controller
( new_route.get/{'books' => :controller}/:book_id > :show ).
test do
  MATCH get('/books/22'),
    { :book_id => '22',
      :controller => 'books', :action => 'show' }
  
  FAILS get('/books/22/bla')
end

# two routes
new_routes do
  
  # long form
  match.method(:get).segment('').controller(:my_controller).action(:my_action)
  # short form
  get/{'books' => :controller}/:book_id > :show
   
end.test do
  
  MATCH get('/'), 
    { :controller => 'my_controller', :action => 'my_action' }
    
  MATCH get('/books/22'),
    { :controller => 'books', :action => 'show', :book_id => '22' }
  
end

# ok, lets get serious
new_routes do
  
  get.root >> :menus > :fa_coffee
  
  get/{'tests' => :controller}/:action
  
  get/'user.js' >> :users > :find_or_create

  with match/:slug do
    
    get >> :restaraunts > :show
    
    with match/'order' >> :orders do
      post > :create
      get > :show
    end
    
    get /{'item_images' => :controller}/{/.+/ => :image} > :show
    
  end
  
end.test do
  
  MATCH get('/'), 
    { :controller => 'menus', :action => 'fa_coffee' }
  
  MATCH get('/tests/some_action'), 
    { :controller => 'tests', :action => 'some_action' }
  
  MATCH get('/user.js'), 
    { :controller => 'users', :action => 'find_or_create' }
  
  MATCH get('/fa-coffee-on-oxford'), 
    { :slug => 'fa-coffee-on-oxford', :controller => 'restaraunts', :action => 'show' }
  
  MATCH post('/fa-coffee-on-oxford/order'),
    { :slug => 'fa-coffee-on-oxford', :controller => 'orders', :action => 'create' }
  
  MATCH get('/fa-coffee-on-oxford/item_images/myimage.gif'),
    { :slug => 'fa-coffee-on-oxford', :controller => 'item_images', :action => 'show', :image => 'myimage.gif' }
  
  FAILS get('/fa-coffee-dkasdas/dasdasd')
  
end