module FcrepoAdmin::Controller
  module ObjectsControllerBehavior
    extend ActiveSupport::Concern

    included do
      layout 'fcrepo_admin/objects'
      include FcrepoAdmin::Controller::ControllerBehavior
      helper_method :object_properties
      before_filter :load_and_authorize_object, :except => :show
      before_filter :load_apo_info, :only => :permissions
    end
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    def show
      @response, @document = get_solr_response_for_doc_id(params[:id])
      @object = ActiveFedora::SolrService.reify_solr_results([@document], :load_from_solr => true).first
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

    def permissions
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
