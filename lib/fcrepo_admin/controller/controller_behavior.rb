module FcrepoAdmin::Controller
  module ControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :object_is_auditable?
    end

    def object_is_auditable?
      begin
        @object && @object.is_a?(ActiveFedora::Auditable)
      rescue
        false
      end
    end

    protected

    def load_and_authorize_object
      load_object
      authorize_object
    end

    def load_object
      id = params[:object_id] || params[:id]
      @object = ActiveFedora::Base.find(id, :cast => true)
    end

    def authorize_object
      # if params[:controller] == 'fcrepo_admin/objects' && params[:action] == 'audit_trail'
      #   action = :read
      # else
      #   action = params[:action].to_sym
      # end
      # authorize! action, @object
      authorize! params[:action].to_sym, @object
    end

  end
end
