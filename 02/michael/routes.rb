ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resource :user, :member => { :activate => :get }
  
  map.with_options(:controller => "users") do |users|
    map.with_options(:conditions => { :method => :get }) do |users|
      users.login_or_register "login-or-register", :action => "new_with_login"
      users.submit_your_project "submit-your-project", :action => "new_with_login", :type => "project"
      users.nominate_a_staff_member "nominate-a-staff-member", :action => "new_with_login", :type => "staff"
      users.register "register", :action => "new"
      users.register_thankyou "register/thankyou", :action => "thankyou"
      users.members_path "members", :action => "members"
      users.activate "a/:activation_code", :action => "activate", :activation_code => nil
      users.forgot_password "login/forgot-password", :action => "forgot_password"
      users.forgot_password "login/forgot-password", :action => "recall_password"
      users.members "members", :action => "members"
    end
    map.with_options(:conditions => { :method => :post }) do |users|
      users.register "register", :action => "create"
    end
  end

  (map/{'users'=>:controller}).map do |user|
    users
  end
  

  map.namespace :members do |members|
    members.resources :projects,
      :collection => {:conditions => :get},
      :member => {
        :print => :get,
        :summary => :any,
        :award_category => :any,
        :objectives => :any,
        :processes_activities => :any,
        :stakeholders_involvement => :any,
        :council_commitment => :any,
        :project_outcomes => :any,
        :accessibility => :any,
        :cost_effectiveness => :any,
        :supporting_material => :any,
        :cultural_policy_document => :any,
        :application_confirmation => :any,
        :photos => :get,
        :videos => :get,
        :audio_files => :get,
        :promotional_tools => :get
      } do |projects|
      projects.resources :photos, :controller => "ProjectPhotos", :member => {:delete => :get}
      projects.resources :videos, :controller => "ProjectVideos", :member => {:delete => :get}
      projects.resources :audio_files, :controller => "ProjectAudioFiles", :member => {:delete => :get}
    end

    members.resources :nominees,
      :collection => {:conditions => :get},
      :member => {
        :print => :get,
        :name => :any,
        :commitment_to_local_cultural_development => :any,
        :aboriginal_cultural_development => :any,
        :substantial_body_of_work => :any,
        :innovative_contribution_to_range_and_scope => :any,
        :application_confirmation => :any,
      }
      
    members.resources :discussions, :member => {:subscribe => :post} do |discussions|
      discussions.resources :replies
    end
  end

  map.resource :session
  map.with_options(:controller => "sessions") do |sess|
    sess.login "login",   :action => "new",     :conditions => { :method => :get }
    sess.login "login",   :action => "create",  :conditions => { :method => :post }
    sess.logout "logout", :action => "delete" , :conditions => { :method => :get }                                
    sess.logout "logout", :action => "destroy", :conditions => { :method => :post }
  end
  
  map.connect 'pages/:page' :controller => :pages, :action => :show
  
  class PageController
    
    # def show
    #   render :action => params[:page].gsub('-','_')
    # rescue RenderError
    #   raise RouteError
    # end
    
  end
  
  link_to page_sponsors_message_path
  
  link_to pages_path(:page => 'sponsors-message')
  
  link_to path/'sponsors-message'
  
  map.with_options(:controller => "pages") do |pages|
    pages.sponsors_message          "sponors-message",         :action => "sponsors_message"
    pages.privacy_policy            "privacy-policy",          :action => "privacy_policy"
    pages.disclaimer                "disclaimer",              :action => "disclaimer"
    pages.home                      "",                        :action => "home"
    pages.formatted_recent_activity "recent-activity.:format", :action => "recent_activity"
    pages.feeds                     "feeds",                   :action => "feeds"
    pages.hartnett                  "brendan-hartnett",        :action => "hartnett"
  end
  
  map.connect "dasojd/:dklsd(dsakldj)"
  
  map.get.join({'pages' => :controller}).map do |map|
    map/'sponsors_message' > 'sponsors_message'
  end
  
  map.with_options(:controller => "about") do |pages|
    pages.about                       "about",                              :action => "index"
    pages.about_register              "about/how-to-register",              :action => "register"
    pages.about_submit_project        "about/how-to-submit-project",        :action => "submit_project"
    pages.about_nominate_individual   "about/how-to-nominate-individual",   :action => "nominate_individual"
    pages.about_award_categories      "about/award-categories",             :action => "award_categories"
    pages.about_award_divisions       "about/award-divisions",              :action => "award_divisions"
    pages.about_prizes                "about/prizes",                       :action => "prizes"
    pages.about_conditions            "about/conditions-of-entry",          :action => "conditions"
  end
  
  map.resources :blogs, :as => "blog"
  
  map.resources :projects, :collection => {
    :all => :get,
    :chronology => :get,
    :councils => :get,
    :awards => :get,
    :winners => :get,
    :photos => :get,
    :videos => :get
    } do |projects|
    projects.resources :votes, :controller => "PeoplesChoiceVotes"
  end
  map.project_photo "projects/:project_id/photos/:id", :controller => "ProjectPhotos", :action => "show"
  map.project_video "projects/:project_id/videos/:id", :controller => "ProjectVideos", :action => "show"
    
  map.with_options(:controller => "contact_us") do |contact|
    contact.contact_us "contact-us", :action => "new", :conditions => { :method => :get }
    contact.contact_us "contact-us", :action => "create", :conditions => { :method => :post }
    contact.contact_us_thankyou "contact-us/thankyou", :action => "thankyou"
  end
  
  map.with_options(:controller => "awards_bookings") do |awards_bookings|
    awards_bookings.new_awards_booking      "rsvp",          :action => "new",    :conditions => {:method => :get}
    awards_bookings.awards_bookings         "rsvp",          :action => "create", :conditions => {:method => :post}
    awards_bookings.awards_booking          "rsvp/:id",      :action => "show",   :conditions => {:method => :get}
    awards_bookings.edit_awards_booking     "rsvp/:id/edit", :action => "edit",   :conditions => {:method => :get}
    awards_bookings.awards_booking          "rsvp/:id",      :action => "update", :conditions => {:method => :put}
    awards_bookings.legacy_awards_booking   "RSVP",          :action => "legacy_url"
  end

  map.admin_home "admin", :controller => "admin/pages", :action => "home"
  map.namespace :admin do |admin|
    admin.resources :blogs
    admin.resources :users
    admin.resources :projects
    admin.resources :nominees
    admin.resources :winners, :collection => {
      :hartnett => :any,
      :peoples_choice => :any,
      :accessible_arts => :any,
      :highly_commended => :any,
      :divisional => :any
    }
  end
  
  map.admin_rsvp "admin/rsvp", :controller => "admin/rsvp", :action => "index"
  
  map.admin_exports "admin/exports", :controller => "admin/exports", :action => "index"
  map.admin_export_projects "admin/exports/projects/", :controller => "admin/exports", :action => "completed_projects"
  map.admin_export_projects_files "admin/exports/projects/files/", :controller => "admin/exports", :action => "completed_projects_files"
  map.admin_export_nominations "admin/exports/nominations/", :controller => "admin/exports", :action => "completed_nominations"
  
  map.with_options(:controller => "admin/group_email") do |admin|
    admin.admin_group_email "admin/group-email", :action => "new", :conditions => { :method => :get}
    admin.admin_group_email "admin/group-email", :action => "create", :conditions => { :method => :post}
    admin.admin_group_email_sent "group-email/sent", :action => "sent"
  end
end