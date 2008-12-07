"/companies".r do
  "/".r       :get,  a(:index)
  "/".r       :post, a(:create)
  "/new".r    :get,  a(:new)
  "/search".r :post, a(:search)
  "/:id".r    :get,  a(:show)
  "/:id".r    :put,  a(:update)
  "/edit".r   :get,  a(:edit)
end

"/accounts".r do
  "/new/plan/:plan_id".r :get, a(:new)
end

"/articles".r do
  "/:year/:month/:day/:slug".r :get,  a(:show)
end

"/:year/:month/:day/:slug".r :post, c(:comments), a(:new_comment)

"/particles".r :specs do
  index
  create
  update
end
