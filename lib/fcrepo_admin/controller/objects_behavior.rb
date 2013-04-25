module FcrepoAdmin::Controller
  module ObjectsBehavior
    extend ActiveSupport::Concern

    included do
      layout 'fcrepo_admin/objects'
      include FcrepoAdmin::Controller::ControllerBehavior
      helper_method :object_properties
      before_filter :load_and_authorize_object
      before_filter :load_apo_info, :only => :show
    end
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    def show
    end

    def audit_trail
      if object_is_auditable?
        if params[:download]
          send_data @object.audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
        end
      else
        render :text => I18n.t("fcrepo_admin.object.audit_trail.not_implemented"), :status => 404
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
      @object_properties ||= PROPERTIES.inject(Hash.new) { |h, p| h[p] = @object.send(p); h }
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
