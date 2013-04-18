FcrepoAdmin::Engine.routes.draw do

  scope :module => "fcrepo_admin" do
    resources :objects, :only => :show do
      get 'audit_trail', :on => :member
      resources :datastreams, :only => [:show, :edit, :update] do
        get 'upload', :on => :member
      end
    end
  end
    
end
