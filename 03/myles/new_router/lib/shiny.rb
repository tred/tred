# using newrouter
shiny do
    
  get.root >> :menus > :fa_coffee
  
  get/{'tests' => :controller}/:action
  
  get/'user.js' >> :users > :find_or_create

  with(match/:slug) do
    
    get >> :restaraunts > :show
    get/'menu' >> :menus > :show
    
    with(match/'order' >> :orders) do
      put > :update
      get > :show
    end
    
    match/{'item_images' => :controller}/{:image => /.+/} > :show
    
  end
  
end