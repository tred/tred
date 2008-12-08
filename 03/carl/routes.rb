class SweetRouteMatcher
  def initialize(map)
    @map = map
    @url = ''
  end
  
  attr_accessor :map, :url, :controller, :action, :verb, :name
  [:get, :post, :put, :delete].each do |verb|
    define_method verb do
      self.verb = verb
      self
    end
  end
  
  def set_controller(controller, url)
    self.controller = controller.to_s
    self.url = url
  end
    
  def set_controller_from_hash(controller_desc)
    desc = controller_desc.detect{|str,con| [str,con]}
    url = desc.first; con = desc.last
    self.controller = con.to_s
    self.url = url
  end
  
  def set_action(action)
    self.action = action.to_s
    self.url += '/' + action.to_s
  end
  
  def set_action_from_hash(action_desc)
    desc = action_desc.detect{|str,act| [str,act]}
    u = desc.first; a = desc.last
    self.url += '/' + u
    self.action = a.to_s
  end
  
  def c(controller_desc)
    case controller_desc
    when Symbol
      set_controller controller_desc.to_s, controller_desc.to_s
    when Hash
      set_controller_from_hash controller_desc
    end
    self
  end
  
  alias_method :/, :c
  
  def with
    yield self
  end
    
  def a(action_desc)
    case action_desc
    when Symbol
      set_action action_desc
    when Hash
      set_action_from_hash(action_desc)
    end
    self
  end
  
  alias_method :>>, :a 
  
  def method_missing(name, *args)
    self.name = name.to_s.gsub('!', '')
    connect
    self
  end
  
  def connect
    p "map.connect #{url}, :controller => #{controller}, :action => #{action}, :conditions => {:method => #{verb}}"
    map.send(name || 'connect', url, :controller => controller, 
             :action => action, :conditions => {:method => verb})
    name = nil
  end
end

module SweetRoutes
  def R(sw)
    sw.con
  end
  
  [:get, :post, :put, :delete].each do |verb|
    class_eval do
      define_method verb do
        sw.send verb
      end
    end
  end
  
  def sw
    @sw ||= SweetRouteMatcher.new(@map)
  end
end

ActionController::Routing::Routes.draw do |map|
  @map = map
  include SweetRoutes
  
  #R get.c(:accounts).a('new/plan/:plan_id'=>:new).sign_up!
  #
  #R get.c(:plans).a('' => :index).plans!
  #post.c(:accounts).with do |ac|
  #  R ac.a('' => :create).accounts!
  #  R ac.a('subdomain/:subdomain' => :subdomain).accounts_subdomain!
  #end
  get.c(:companies).with do |com|
    #com.a('' => :index).companies!
    #com.a(:new).new_company!
    com.a(':id' => :show).company!
    com.a(':id/edit' => :edit).edit_company!
  end
  #R post.c(:companies).a('' => :create).companies!
  #R post.c(:companies).a(:search).search_for_company!
  
  #map.with_options :controller => 'companies' do |companies|
  #  companies.with_options :conditions => {:method => :get} do |c|
  #    c.new_company 'companies/new', :action => 'new'
  #    c.companies 'companies', :action => 'index'
  #    c.company 'companies/:id', :action => 'show'
  #    c.edit_company 'companies/:id/edit', :action => 'edit'
  #  end
  #  companies.with_options :conditions => {:method => :post} do |c|
  #    c.companies 'companies', :action => 'create'
  #    c.search_for_company 'companies/search', :action => 'search'
  #  end
  #  companies.company 'companies/:id', :action => 'update', :conditions => {:method => :put}
  #end
  
  map.with_options :controller => 'people' do |people|
    people.with_options :conditions => {:method => :get} do |p|
      p.person 'people/:id', :action => 'show'
      p.edit_person 'people/:id/edit', :action => 'edit'
      p.new_person 'companies/:company_id/people/new', :action => 'new'
    end
    people.person 'people/:id', :action => 'update', :conditions => {:method => :put}
    people.people 'companies/:company_id/people', :action => 'create', :conditions => {:method => :post}
  end
  
  map.with_options :controller => 'notes' do |notes|
    notes.company_notes 'companies/:company_id/notes', :action => 'create', :conditions => {:method => :post}
  end
  
  map.new_login 'sessions/new', :controller => 'sessions', :action => 'new', :conditions => {:method => :get}
  map.login 'sessions', :controller => 'sessions', :action => 'create', :conditions => {:method => :post}
  map.delete_login 'sessions', :controller => 'sessions', :action => 'destroy', :conditions => {:method => :delete}
  map.new_basecamp_login 'basecamp_logins/new', :controller => 'basecamp_logins', :action => 'new', :conditions => {:method => :get}
  map.basecamp_logins 'basecamp_logins', :controller => 'basecamp_logins', :action => 'create', :conditions => {:method => :post}
  map.import_companies_from_basecamp_login 'basecamp_login/import_companies', :controller => 'basecamp_logins', :action => 'import_companies', :conditions => {:method => :post}
  map.dashboard '', :controller => 'plans'
end