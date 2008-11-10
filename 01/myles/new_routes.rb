ActionController::Routing::NewRoutes.create do |map|
  
  #map.method(:get).path('/').to.controller(:menus).action(:fa_coffee)
  
  map.get.root >> :menus > :fa_coffee
  
  #(map.get/'tests'/:action).to :controller => :tests
  
  map.get / {'tests' => :controller} / :action
  
  map.get / 'user.js' >> :users > :find_or_create

  (map / :slug).map do |slug|

    (slug/'order').controller(:orders) do |order|
      order.put > :update
      order.get > :show
    end
    
    slug / {'item_images' => :controller} / {:image => /.+/}
    
  end
  
  (map/'bank_accounts'/:bank_account_id) do |map|
    
    (map/'bank_imports'/:bank_import_id) do |map|
      
      (map/'bank_import_line_items'/:bank_import_line_item_id) do |map|
        
        (map/'bank_import_line_item_allocations'/:bank_import_line_item_allocation_id) do
          
          
          
        end
        
      end
      
    end
    
  end
  
  (map/'somthing'/:anything => %r{.+}) >> :my_controller > :dispatch
  
  (map/'bank').namespace(:bank) do
  
    (map/'accounts'/:_id) do |map|
    
      (map/'imports'/:_id) do |map|
      
        (map/'import_line_items'/:_id).nest do |map|
        
          (map/'import_line_item_allocations'/:_id) do |map|
          
            map.get >> :import_line_item_allocations > :show
          
          end
        
        end
      
      end
    
    end
  
  end
  
end

# path_expansions do 
#   case Restaurant: "restaurants/:slug"
#   
# end

path.expand(BankImportLineItemAllocation, [:import_line_item,:import,:account])

admin_restaurants_menu_item_images_path(@restaurant)

path/:admin/@restaurant/:item_images

path/@bank_account/@import_line_item_allocation


path/:admin/:restaurants/@restaurant.slug/:item_images