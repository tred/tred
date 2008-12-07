map.sign_up 'accounts/new/plan/:plan_id', :controller => 'accounts', :action => 'new'
map.with_options :controller => 'companies' do |companies|
  companies.with_options :conditions => {:method => :get} do |c|
    c.new_company 'companies/new', :action => 'new'
    c.companies 'companies', :action => 'index'
    c.company 'companies/:id', :action => 'show'
    c.edit_company 'companies/:id/edit', :action => 'edit'
  end
  companies.with_options :conditions => {:method => :post} do |c|
    c.companies 'companies', :action => 'create'
    c.search_for_company 'companies/search', :action => 'search'
  end
  companies.company 'companies/:id', :action => 'update', :conditions => {:method => :put}
end

map.sign_up 'accounts/new/plan/:plan_id', :controller => 'accounts', :action => 'new'

map.with_options(:controller => 'article',
                 :requirements => { :year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }) do |article|
  article.article 'article/:year/:month/:day/:permalink' , :action => 'show'
  article.new_comment 'article/:year/:month/:day/:permalink/comment', :action => 'new_comment'
  article.new_comment_form 'article/:year/:month/:day/:permalink/comment_form', :action => 'comment_form'
  article.who_am_i 'who-am-i', :action => 'who_am_i'
  article.subscribe 'subscribe', :action => 'subscribe'
  article.home '', :action => 'index'
end
