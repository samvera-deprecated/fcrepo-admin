module FcrepoAdmin::Controller
  module CatalogControllerBehavior

    def search_action_url
      url_for(:controller => '/catalog', :action => 'index', :only_path => true)
    end

  end
end
