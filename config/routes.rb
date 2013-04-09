FcrepoAdmin::Engine.routes.draw do

  scope ":object_id", :module => "fcrepo_admin" do
    resources :datastreams, :only => [:index, :show] do
      member do
        get 'download'
      end
    end
    resources :audit_trail, :only => :index
  end
    
end
