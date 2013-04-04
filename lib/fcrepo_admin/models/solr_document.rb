require 'json'

module FcrepoAdmin::Models
  module SolrDocument

    def object_profile
      # FIXME hard-coded field name
      @object_profile ||= JSON.parse(self['object_profile_ssm'].first)
    end

    def datastreams
      object_profile["datastreams"]
    end
    
    def has_datastream?(dsID)
      #!(datastreams[dsID].nil? || datastreams[dsID].empty?)
      !datastreams[dsID].blank?
    end

    def has_admin_policy?
      !admin_policy_uri.blank?
    end

    def admin_policy_uri
      # FIXME hard-coded field name
      get(:is_governed_by_s)
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
    
    def has_content?
      has_datastream?("content")
    end
    
  end
end
