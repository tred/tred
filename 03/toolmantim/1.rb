c :companies do
  a :index,  "/",       :get
  a :create, "/",       :post
  a :new,    "/new",    :get
  a :search, "/search", :post
  a :show,   "/:id",    :get
  a :update, "/:id",    :put
  a :edit,   "/:id/edit", :get
end

c :accounts do
  a :new, "/new/plan/:plan_id", :get
end

c :articles do
  a :show,        "/:year/:month/:day/:slug", :get
  a :new_comment, "/:year/:month/:day/:slug", :get
end

c :particles, "/specs" do
  index
  create
  update
end
