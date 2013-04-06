require 'json'

module FcrepoAdmin
  module SolrDocumentExtension

    def object_profile
      @object_profile ||= JSON.parse(self[ActiveFedora::Base.profile_solr_name].first)
    end

    def datastreams
      object_profile["datastreams"]
    end
    
    def has_datastream?(dsID)
      !datastreams[dsID].blank?
    end

    def has_admin_policy?
      !admin_policy_uri.blank?
    end

    def admin_policy_uri
      get ActiveFedora::SolrService.solr_name('is_governed_by', :symbol)
    end

    def admin_policy_pid
      uri = admin_policy_uri
      uri &&= ActiveFedora::Base.pids_from_uris(uri)
    end

    def has_parent?
      !parent_uri
    end

    def parent_uri
      get(ActiveFedora::SolrService.solr_name('is_part_of', :symbol)) || get(ActiveFedora::SolrService.solr_name('is_member_of', :symbol)) || get(ActiveFedora::SolrService.solr_name('is_member_of_collection', :symbol))
    end

    def parent_pid
      uri = parent_uri
      uri &&= ActiveFedora::Base.pids_from_uris(uri)
    end

    def active_fedora_model
      get(ActiveFedora::SolrService.solr_name('active_fedora_model', :symbol))
    end
    
  end
end
