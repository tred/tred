# using newrouter
shiny do
  
  defaults do
    put > :update
    get > :show
  end
    
  get /'' >> :menus > :fa_coffee
  
  get /{'tests' => :controller}/:action
  
  get /'user.js' >> :users > :find_or_create

  get /:slug         >> :restaraunts > :show
  get /:slug/'menu'  >> :menus       > :show
  get /:slug/'order' >> :orders

  with match/:slug do
    
    get >> :restaraunts > :show
    get/'menu' >> :menus > :show
    
    match/'order' >> :orders
    
    with(match/'order' >> :orders) do
      put > :update
      get > :show
    end
    
    match/{'item_images' => :controller}/{:image => /.+/} > :show
    
  end
  
end