module FcrepoAdmin::Controller
  module ControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :object_is_auditable?
      helper_method :object_is_governable?
      helper_method :object_is_governed_by
      helper_method :admin_policy_enforcement_enabled?
    end

    protected

    def load_and_authorize_object
      load_object
      authorize_object
    end

    def load_object
      id = params[:object_id] || params[:id]
      begin
        @object = ActiveFedora::Base.find(id, :cast => true)
      rescue ActiveFedora::ObjectNotFoundError
        render :text => "Object not found", :status => 404
      end
    end

    def authorize_object
      authorize! params[:action].to_sym, @object
    end

    def object_is_auditable?
      begin
        @object && @object.is_a?(ActiveFedora::Auditable)
      rescue
        false
      end
    end

    def admin_policy_enforcement_enabled?
      # Including Hydra::PolicyAwareAccessControlsEnforcement in ApplicationController 
      # appears to be the only way that APO access control enforcement can be enabled.
      self.class.ancestors.include?(Hydra::PolicyAwareAccessControlsEnforcement)
    end

    def object_is_governed_by
      @object_is_governed_by ||= object_is_governable? && @object.send(is_governed_by_association_name)
    end

    def object_is_governable?
      !is_governed_by_association_name.nil?
    end

    def is_governed_by_association_name
      @object.reflections.each do |name, reflection|
        if reflection.macro == :belongs_to && reflection.options[:property] == :is_governed_by # && reflection.class_name == admin_policy_class.to_s
          return reflection.name
        end
      end
    end

    def admin_policy_class
      # XXX Ideally we would use Hydra::PolicyAwareAccessControlsEnforcement#policy_class,
      # but it's only available if it's been included in the application controller, i.e.,
      # if APO access control enforcement is enabled.  We want to know the name of the
      # relationship regardless of whether policy enforcement is enabled.
      Hydra.config[:permissions].fetch(:policy_class, Hydra::AdminPolicy)
    end

  end
end
