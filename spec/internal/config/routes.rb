Rails.application.routes.draw do
  Blacklight.add_routes(self)
  root :to => "catalog#index"
  devise_for :users
  mount FcrepoAdmin::Engine => "/admin", :as => 'fcrepo_admin'
end
