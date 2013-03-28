class PreservationEventsController < CatalogController
  
  self.solr_search_params_logic += [:preservation_events_filter]
  self.blacklight_config = Blacklight::Configuration.new

  configure_blacklight do |config|
    config.add_index_field :id
    config.add_index_field :event_type_ssim
    config.add_index_field :event_outcome_ssim
    config.add_index_field :event_date_time_dt
  end

  def index
    @title = params[:object_id]
    @response, @document_list = get_search_results
  end

end