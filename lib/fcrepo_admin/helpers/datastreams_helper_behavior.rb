module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def datastream_context_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_context_nav_items
      render :partial => 'fcrepo_admin/datastreams/context_nav_items', :locals => {:object => @object, :datastream => @datastream}
    end

    def datastream_index_columns
      ["dsLabel", "dsMIME", "dsCreateDate"]
    end

    def datastream_history_columns
      ["dsCreateDate"]
    end

    def datastream_params
      params.has_key?(:asOfDateTime) ? {:asOfDateTime => params[:asOfDateTime]} : {}
    end

    def datastream_not_current_version?
      params.has_key?(:asOfDateTime)
    end

    def can_edit_datastream?
      can? :edit, @object
    end

    def can_upload_datastream?
      can? :upload, @object
    end

  end
end
