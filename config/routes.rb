FcrepoAdmin::Engine.routes.draw do

  scope :module => "fcrepo_admin" do
    resources :objects, :only => :show do
      resources :datastreams, :only => [:index, :show] do
        member do
          get 'download'
        end
      end
      resources :audit_trail, :only => :index
    end
  end
    
end
