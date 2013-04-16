module FcrepoAdmin
  class ObjectsController < ApplicationController

    include FcrepoAdmin::ControllerBehavior
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    helper_method :apo_enforcement_enabled?
    helper_method :object_properties

    before_filter { |c| c.load_and_authz_object :id }
    before_filter :load_apo_info   # depends on load_and_authz_object

    def show
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

    def load_apo_info
      @apo_relationship_name = nil
      @apo = nil
      # XXX Ideally we would use Hydra::PolicyAwareAccessControlsEnforcement#policy_class,
      # but it's only available if it's been included in the application controller, i.e.,
      # if APO access control enforcement is enabled.  We want to know the name of the
      # relationship regardless of whether policy enforcement is enabled.
      apo_class = Hydra.config[:permissions].fetch(:policy_class, Hydra::AdminPolicy)
      @object.reflections.each_value do |reflection|
        if reflection.options[:property] == :is_governed_by \
          && reflection.macro == :belongs_to #&& reflection.class_name == apo_class.to_s
          @apo_relationship_name = reflection.name
          @apo = @object.send(@apo_relationship_name)
          break
        end
      end
      
    end

  end
end
