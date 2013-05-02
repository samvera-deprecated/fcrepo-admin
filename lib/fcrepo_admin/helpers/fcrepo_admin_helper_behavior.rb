module FcrepoAdmin::Helpers
  module FcrepoAdminHelperBehavior

    def object_has_permissions?
      @object.is_a?(Hydra::ModelMixins::RightsMetadata)
    end

    def object_context_nav_items
      items = []
      items << [t("fcrepo_admin.object.nav.items.datastreams"), fcrepo_admin.object_datastreams_path(@object)]
      items << [t("fcrepo_admin.object.nav.items.properties"), fcrepo_admin.properties_object_path(@object)]
      items << [t("fcrepo_admin.object.nav.items.permissions"), fcrepo_admin.permissions_object_path(@object)] if object_has_permissions?
      items << [t("fcrepo_admin.object.nav.items.associations"), fcrepo_admin.object_associations_path(@object)]
      items << [t("fcrepo_admin.object.nav.items.audit_trail"), fcrepo_admin.audit_trail_object_path(@object)] if object_is_auditable?
      items
    end

    def object_context_nav_header
      t("fcrepo_admin.object.nav.header")
    end

    def render_object_context_nav
      render :partial => 'fcrepo_admin/shared/context_nav', :locals => {:header => object_context_nav_header, :items => object_context_nav_items}
    end

  end
end
