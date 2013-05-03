module FcrepoAdmin::Controller
  module AssociationsControllerBehavior
    extend ActiveSupport::Concern
    
    included do
      layout 'fcrepo_admin/objects'

      include FcrepoAdmin::Controller::ControllerBehavior

      before_filter :load_and_authorize_object
      before_filter :load_association, :only => :show
    end

    def index
    end

    def show
      if @association.collection?
        self.solr_search_params_logic += [:association_filter]
        @response, @documents = get_search_results({:qt => 'standard'})
      else
        target = @object.send("#{@association.name}_id")
        if target
          redirect_to :controller => 'objects', :action => 'show', :id => target, :use_route => 'fcrepo_admin'
        else
          render :text => "Target not found", :status => 404
        end
      end
    end

    def association_filter(solr_params, user_params)
      solr_params[:q] = construct_query
    end

    protected

    # Copied from ActiveFedora::Associations::AssociationCollection
    def construct_query
      clauses = {@association.options[:property] => @object.internal_uri}
      clauses[:has_model] = @association.class_name.constantize.to_class_uri if @association.class_name && @association.class_name != 'ActiveFedora::Base'
      ActiveFedora::SolrService.construct_query_for_rel(clauses)
    end

    def load_association
      @association = @object.reflections[params[:id].to_sym] # XXX raise exception if nil
    end

  end
end
