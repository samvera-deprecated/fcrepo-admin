FcrepoAdmin::Engine.routes.draw do

  datastreams_resources = [:index, :show]
  datastreams_resources += [:edit, :update] unless FcrepoAdmin.read_only

  scope :module => "fcrepo_admin" do
    resources :objects, :only => :show do
      member do
        get 'audit_trail'
        get 'solr'
        get 'permissions'
      end
      resources :associations, :only => [:index, :show]
      resources :datastreams, :only => datastreams_resources do
        member do
          get 'content'
          get 'upload' unless FcrepoAdmin.read_only
          get 'download' => 'download#show'
          get 'history'
        end
      end
    end
  end
    
end
