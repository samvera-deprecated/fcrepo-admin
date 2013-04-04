module FcrepoAdmin::SolrHelper
  
  def af_model_filter(solr_params, user_params)
    solr_params[:fq] ||= []
    solr_params[:fq] << "+#{solr_name('active_fedora_model', :symbol)}:#{user_params[:model]}"
  end

end
