module FcrepoAdmin::Helpers
  module FcrepoAdminHelperBehavior

    def object_has_permissions?
      @object.is_a?(Hydra::ModelMixins::RightsMetadata)
    end

    def object_context_nav_header
	  t("fcrepo_admin.object.nav.header")
    end

    def object_context_nav_items
      render :partial => 'fcrepo_admin/objects/context_nav_items', :locals => {:object => @object}
    end

  end
end
