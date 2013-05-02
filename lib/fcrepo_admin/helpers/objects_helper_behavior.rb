module FcrepoAdmin::Helpers
  module ObjectsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def object_title
      "#{object_type} #{@object.pid}"
    end

    def object_type
      @object.class.to_s
    end

    def object_has_permissions?
      @object.is_a?(Hydra::ModelMixins::RightsMetadata)
    end

    def object_model_belongs_to_apo?
      !@apo_relationship_name.nil?
    end

    def object_admin_policy
      @object_admin_policy
    end

    def object_has_admin_policy?
      !object_admin_policy.nil?
    end

    def object_has_inherited_permissions?
      object_has_admin_policy?
    end

    def object_inherited_permissions
      object_admin_policy && object_admin_policy.default_permissions
    end

    def admin_policy_enforcement_enabled?
      @apo_enforcement_enabled
    end

    def admin_policy_object?
      # XXX Ideally we would use Hydra::PolicyAwareAccessControlsEnforcement#policy_class,
      # but it's only available if it's been included in the application controller, i.e.,
      # if APO access control enforcement is enabled.  We want to know the name of the
      # relationship regardless of whether policy enforcement is enabled.
      @object.is_a?(Hydra.config[:permissions].fetch(:policy_class, Hydra::AdminPolicy))
    end
    
  end
end
