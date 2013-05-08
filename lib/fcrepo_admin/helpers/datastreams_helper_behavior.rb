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

    def format_ds_profile_value(profile, key)
      value = profile[key]
      case
      when key == "dsSize" then number_to_human_size(value)
      when key == "dsCreateDate" then value.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      when key == "dsLocation" && ['E','R'].include?(profile["dsControlGroup"]) then link_to(value, value)
      else value
      end
    end

    def datastream_params
      params.has_key?(:asOfDateTime) ? {:asOfDateTime => params[:asOfDateTime]} : {}
    end

  end
end
