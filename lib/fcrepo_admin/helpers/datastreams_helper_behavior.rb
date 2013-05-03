module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def datastream_context_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_context_nav_items
      render :partial => 'fcrepo_admin/datastreams/context_nav_items', :locals => {:object => @object, :datastream => @datastream}
    end

    def can_edit_datastream?
      can? :edit, @object
    end

    def can_upload_datastream?
      can? :upload, @object
    end

    def can_download_datastream?
      can? :download, @object
    end

  end
end
