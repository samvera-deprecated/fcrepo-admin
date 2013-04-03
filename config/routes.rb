#require 'devise'

FcrepoAdmin::Engine.routes.draw do

  #root :to => "catalog#index"

  #Blacklight.add_routes(self) #, :only => [:catalog])

  # devise_for :users, {
  #   module: :devise
  # }

  scope "catalog/:object_id" do
    # get 'thumbnail' => 'thumbnail#show'
    resources :datastreams, :only => :show do
      member do
        get 'download'
      end
    end
    resources :audit_trail, :only => :index
  end
    
end
