r "/companies", do
  a "/",       :get,  :index
  a "/",       :post, :create
  a "/new",    :get,  :new
  a "/search", :post, :search
  a "/:id",    :get,  :show
  a "/:id",    :put,  :update
  a "/edit",   :get,  :edit
end

r "/accounts" do
  a "/new/plan/:plan_id", :get, :new
end

r "/articles" do
  a "/:year/:month/:day/:slug", :get, :show
  a "/:year/:month/:day/:slug", :post, :new_comment
end

r "/particles", :specs do
  index
  create
  update
end
