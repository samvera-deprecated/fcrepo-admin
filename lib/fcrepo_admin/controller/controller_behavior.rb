module FcrepoAdmin::Controller
  module ControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :object_is_governed_by
    end

    protected

    def load_and_authorize_object
      load_object
      authorize_object
    end

    def load_object
      pid = params[:object_id] || params[:id]
      begin
        @object = ActiveFedora::Base.find(pid, :cast => true)
      rescue ActiveFedora::ObjectNotFoundError
        render :text => "Object not found", :status => 404
      end
    end

    def authorize_object
      authorize! params[:action].to_sym, @object
    end

    def object_is_governed_by
      @object_is_governed_by ||= @object.send(@object.governed_by_association.name) rescue nil
    end

    # #solr_response_for_raw_result and #solr_documents_for_response
    # duplicate Blacklight functionality outside of a full Blacklight
    # catalog controller context.
    def solr_response_for_raw_result(solr_result)
      Blacklight::SolrResponse.new(solr_result, {})
    end

    def solr_documents_for_response(solr_response)
      solr_response.docs.collect { |doc| SolrDocument.new(doc, solr_response) }
    end

  end
end
