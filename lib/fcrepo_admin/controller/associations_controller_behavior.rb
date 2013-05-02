module FcrepoAdmin::Controller
  module AssociationsControllerBehavior
    extend ActiveSupport::Concern
    
    included do
      layout 'fcrepo_admin/objects'
      include FcrepoAdmin::Controller::ControllerBehavior
      before_filter :load_and_authorize_object
      before_filter :load_association
    end

    def show
      if @association.collection?
        @documents = @object.send(@association.name).load_from_solr.collect { |r| SolrDocument.new(r) }
      else
        associated = @object.send(@association.name)
        if associated
          # redirect to associated object
        end
      end
    end

    protected

    def load_association
      @association = @object.reflections[params[:id].to_sym] # XXX raise exception if nil
    end

  end
end
