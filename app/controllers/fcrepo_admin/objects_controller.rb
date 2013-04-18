module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    helper_method :apo_enforcement_enabled?
    helper_method :object_properties
    helper_method :admin_policy_object?
    helper_method :object_type
    helper_method :has_permissions?

    before_filter :load_and_authorize_object
    before_filter :load_apo_info, :only => :show  # depends on load_and_authz_object

    def show
    end

    def audit_trail
      # XXX Update when new version of ActiveFedora released
      @audit_trail = @object.respond_to?(:audit_trail) ? @object.audit_trail : @object.inner_object.audit_trail
      if params[:download]
        send_data @audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
      end
    end

    private

    def load_and_authorize_object
      load_object
      authorize_object
    end

    def load_object
      @object = ActiveFedora::Base.find(params[:id], :cast => true)
    end

    def authorize_object
      action = params[:action] == 'audit_trail' ? :read : params[:action].to_sym
      authorize! action, @object
    end

    protected

    def apo_enforcement_enabled?
      # Including Hydra::PolicyAwareAccessControlsEnforcement in ApplicationController 
      # appears to be the only way that APO access control enforcement can be enabled.
      self.class.ancestors.include?(Hydra::PolicyAwareAccessControlsEnforcement)    
    end

    def object_properties
      properties = {}
      PROPERTIES.each { |p| properties[p] = @object.send(p) }
      properties
    end

    def object_type
      @object.class.to_s
    end

    def load_apo_info
      @apo_relationship_name = nil
      @apo = nil
      @object.reflections.each_value do |reflection|
        if reflection.options[:property] == :is_governed_by \
          && reflection.macro == :belongs_to
          @apo_relationship_name = reflection.name
          @apo = @object.send(@apo_relationship_name)
          break
        end
      end
    end

    def has_permissions?
      @object.is_a?(Hydra::ModelMixins::RightsMetadata)
    end

    def admin_policy_object?
      @object.is_a?(apo_class)
    end

    def apo_class
      # XXX Ideally we would use Hydra::PolicyAwareAccessControlsEnforcement#policy_class,
      # but it's only available if it's been included in the application controller, i.e.,
      # if APO access control enforcement is enabled.  We want to know the name of the
      # relationship regardless of whether policy enforcement is enabled.
      Hydra.config[:permissions].fetch(:policy_class, Hydra::AdminPolicy)
    end

  end
end
