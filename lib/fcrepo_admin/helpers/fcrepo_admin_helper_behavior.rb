module FcrepoAdmin::Helpers
  module FcrepoAdminHelperBehavior

    def object_context_nav_items
      items = []
      items << [t("fcrepo_admin.object.nav.items.summary"), fcrepo_admin.object_path(@object)]
      if object_is_auditable?
        items << [t("fcrepo_admin.object.nav.items.audit_trail"), fcrepo_admin.audit_trail_object_path(@object)]
      end
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
