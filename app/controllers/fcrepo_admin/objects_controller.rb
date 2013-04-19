module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    helper_method :object_properties

    before_filter :load_and_authorize_object
    before_filter :load_apo_info, :only => :show

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

    def object_properties
      unless @object_properties
        @object_properties = {}
        PROPERTIES.each { |p| @object_properties[p] = @object.send(p) }
      end
      @object_properties
    end

    def apo_relationship_name
      @object.reflections.each_value do |reflection|
        # XXX This test should also check that reflection class is identical to admin policy class
        return reflection.name if reflection.options[:property] == :is_governed_by && reflection.macro == :belongs_to
      end
      nil
    end

    def load_apo_info
      @apo_relationship_name ||= apo_relationship_name
      @object_admin_policy ||= @apo_relationship_name ? @object.send(@apo_relationship_name) : nil
      # Including Hydra::PolicyAwareAccessControlsEnforcement in ApplicationController 
      # appears to be the only way that APO access control enforcement can be enabled.
      @apo_enforcement_enabled ||= self.class.ancestors.include?(Hydra::PolicyAwareAccessControlsEnforcement)
    end

  end
end
