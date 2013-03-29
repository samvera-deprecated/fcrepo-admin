module DulHydra::SolrHelper
  
  def af_model_filter(solr_params, user_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << "+#{solr_name('active_fedora_model', :symbol)}:#{user_params[:model]}"
  end

  def preservation_events_filter(solr_params, user_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << "+#{solr_name('is_preservation_event_for', :symbol)}:\"info:fedora/#{user_params[:object_id]}\""
  end

  def targets_filter(solr_params, user_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << "+#{solr_name('is_external_target_for', :symbol)}:\"info:fedora/#{user_params[:object_id]}\""
    solr_params[:sort] = ["id asc"]
  end

  def children_filter(solr_params, user_params)
    solr_params[:fq] ||= []
    object_uri = ActiveFedora::SolrService.escape_uri_for_query("info:fedora/#{user_params[:object_id]}")
    solr_params[:fq] << "#{solr_name('is_member_of', :symbol)}:#{object_uri} OR #{solr_name('is_member_of_collection', :symbol)}:#{object_uri} OR #{solr_name('is_part_of', :symbol)}:#{object_uri}"
    solr_params[:sort] = ["id asc"]
  end

end
