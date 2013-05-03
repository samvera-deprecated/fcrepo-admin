FcrepoAdmin::Engine.routes.draw do

  scope :module => "fcrepo_admin" do
    resources :objects, :only => :show do
      member do
        get 'audit_trail'
        get 'permissions'
      end
      resources :associations, :only => [:index, :show]
      resources :datastreams, :only => [:index, :show, :edit, :update] do
        member do
          get 'upload'
          get 'download'
        end
      end
    end
  end
    
end
