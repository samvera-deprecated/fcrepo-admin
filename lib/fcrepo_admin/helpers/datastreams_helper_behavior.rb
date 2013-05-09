module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def datastream_context_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_context_nav_items
      render :partial => 'fcrepo_admin/datastreams/context_nav_items', :locals => {:object => @object, :datastream => @datastream}
    end

    # List of ds profile keys for ds index view
    def datastream_index_columns
      ["dsLabel", "dsMIME", "dsSize", "dsCreateDate"]
    end

    # List of ds profile keys for ds history view
    def datastream_history_columns
      ["dsCreateDate"]
    end

    def datastream_params
      params.has_key?(:asOfDateTime) ? {:asOfDateTime => params[:asOfDateTime]} : {}
    end

  end
end
