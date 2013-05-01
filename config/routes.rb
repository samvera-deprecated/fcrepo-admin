FcrepoAdmin::Engine.routes.draw do

  scope :module => "fcrepo_admin" do
    resources :objects, :only => :show do
      get 'associations/:association', :on => :member, :action => 'association', :as => :association
      get 'audit_trail', :on => :member
      resources :datastreams, :only => [:show, :edit, :update] do
        member do
          get 'upload'
          get 'download'
        end
      end
    end
  end
    
end
