module DulHydra::Helpers
  module CatalogHelperBehavior
    
    def internal_uri_to_pid(args)
      ActiveFedora::Base.pids_from_uris(args[:document][args[:field]])
    end

    def internal_uri_to_link(args)
      pid = internal_uri_to_pid(args).first
      # Depends on Blacklight::SolrHelper#get_solr_response_for_doc_id 
      # having been added as a helper method to CatalogController
      response, doc = get_solr_response_for_doc_id(pid)
      title = doc.nil? ? pid : doc.fetch('title_display', pid)
      link_to(title, catalog_path(pid), :class => "parent-link").html_safe
    end
    
  end
end
