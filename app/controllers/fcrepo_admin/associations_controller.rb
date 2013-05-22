module FcrepoAdmin
  class AssociationsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    before_filter :load_association, :only => :show

    def index
    end

    def show
      if @association.nil?
        render :text => "Association not found", :status => 404
      elsif @association.collection?
        get_collection_from_solr
      else 
        # This shouldn't normally happen b/c UI links directly to target object view in this case
        # but we'll handle it gracefully anyway.
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
      ActiveFedora::SolrService.query(construct_collection_query, collection_query_args)
    end

    def collection_query_args
      page = params[:page].blank? ? 1 : params[:page].to_i
      rows = FcrepoAdmin.associated_objects_per_page
      start = (page - 1) * rows
      args = {raw: true, start: start, rows: rows}
      if FcrepoAdmin.associated_objects_sort_param
        args[:sort] = FcrepoAdmin.associated_objects_sort_param
      end
      apply_gated_discovery(args, nil) # add args to enforce Hydra access controls
      args
    end

    def construct_collection_query
      # Copied from ActiveFedora::Associations::AssociationCollection#construct_query
      clauses = {@association.options[:property] => @object.internal_uri}
      clauses[:has_model] = @association.class_name.constantize.to_class_uri if @association.class_name && @association.class_name != 'ActiveFedora::Base'
      ActiveFedora::SolrService.construct_query_for_rel(clauses)
    end

    def load_association
      @association = @object.reflections[params[:id].to_sym]
    end

  end
end
