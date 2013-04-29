module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def datastream_context_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_context_nav_items
      items = []
      items << [t("fcrepo_admin.datastream.nav.items.summary"), fcrepo_admin.object_datastream_path(@object, @datastream.dsid)]
      if can? :edit, @object
        items << [t("fcrepo_admin.datastream.nav.items.edit"), fcrepo_admin.edit_object_datastream_path(@object, @datastream.dsid)]
      end
      items << [t("fcrepo_admin.datastream.nav.items.upload"), fcrepo_admin.upload_object_datastream_path(@object, @datastream.dsid)]
      items << [t("fcrepo_admin.datastream.nav.items.download"), fcrepo_admin.download_object_datastream_path(@object, @datastream.dsid)]
      items
    end

    def render_datastream_context_nav
      render :partial => 'fcrepo_admin/shared/context_nav', :locals => {:header => datastream_context_nav_header, :items => datastream_context_nav_items}
    end

  end
end
