module FcrepoAdmin
  class AssociationsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include Hydra::Controller::ControllerBehavior
    include Hydra::PolicyAwareAccessControlsEnforcement
    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    before_filter :load_association, :only => :show

    def index
    end

    def show
      if @association.collection?
        get_collection_from_solr
      else
        target = @object.send("#{@association.name}_id")
        if target
          redirect_to :controller => 'objects', :action => 'show', :id => target, :use_route => 'fcrepo_admin'
        else
          render :text => "Target not found", :status => 404
        end
      end
    end

    protected

    def get_collection_from_solr
      @response = solr_response_for_raw_result(get_collection_query_result)
      @documents = solr_documents_for_response(@response)
    end

    def get_collection_query_result
      args = {raw: true}
      apply_gated_discovery(args, {}) # add args to enforce Hydra permissions and admin policies
      ActiveFedora::SolrService.query(construct_collection_query, args)
    end

    def construct_collection_query
      # Copied from ActiveFedora::Associations::AssociationCollection#construct_query
      clauses = {@association.options[:property] => @object.internal_uri}
      clauses[:has_model] = @association.class_name.constantize.to_class_uri if @association.class_name && @association.class_name != 'ActiveFedora::Base'
      query = ActiveFedora::SolrService.construct_query_for_rel(clauses)
    end

    def load_association
      @association = @object.reflections[params[:id].to_sym] # XXX raise exception if nil
    end

  end
end
