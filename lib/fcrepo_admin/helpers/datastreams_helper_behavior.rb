module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior

    def datastream_title
      "#{t('fcrepo_admin.datastream.title')}: #{@datastream.dsid}"
    end

    def datastream_context_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_context_nav_items
      FcrepoAdmin.datastream_context_nav_items.collect do |item| 
        content = datastream_context_nav_item(item)
        content unless content.nil?
      end
    end

    def datastream_index_columns
      FcrepoAdmin.datastream_index_columns
    end

    def datastream_history_columns
      FcrepoAdmin.datastream_history_columns
    end

    def datastream_params
      params.has_key?(:asOfDateTime) ? {:asOfDateTime => params[:asOfDateTime]} : {}
    end

    def datastream_context_nav_item(item)
      condition = case
                  when item == :current_version then !@datastream.current_version?
                  when item == :summary         then true
                  when item == :content         then @datastream.content_is_text?
                  when item == :download        then @datastream.content_is_downloadable?
                  when item == :edit            then @datastream.content_is_editable? && can?(:edit, @object)
                  when item == :upload          then @datastream.content_is_uploadable? && can?(:upload, @object)
                  when item == :history         then !@datastream.new?
                  end
      custom_datastream_context_nav_item(item) if condition.nil?
      link_to_datastream(item) if condition
    end

    def custom_datastream_context_nav_item(item)
      # Override this method with your custom items
    end

    def link_to_datastream_version(dsVersion)
      link_to_unless dsVersion.current_version?, dsVersion.dsVersionID, fcrepo_admin.object_datastream_path(@object, @datastream, :asOfDateTime => ds.asOfDateTime) do |name|
        "#{name} (current version)"
      end
    end

    def link_to_datastream(view)
      path = case
             when view == :current_version then fcrepo_admin.object_datastream_path(@object, @datastream)
             when view == :summary         then fcrepo_admin.object_datastream_path(@object, @datastream, datastream_params)
             when view == :content         then fcrepo_admin.content_object_datastream_path(@object, @datastream, datastream_params)
             when view == :download        then fcrepo_admin.download_object_datastream_path(@object, @datastream, datastream_params)
             when view == :edit            then fcrepo_admin.edit_object_datastream_path(@object, @datastream)
             when view == :upload          then fcrepo_admin.upload_object_datastream_path(@object, @datastream)
             when view == :history         then fcrepo_admin.history_object_datastream_path(@object, @datastream)
             end
      label = t("fcrepo_admin.datastream.nav.items.#{view}")
      if view == :current_version || view == :download
        link_to label, path
      else
        link_to_unless_current label, path
      end
    end

    def render_datastream_version
      render :partial => 'version', :locals => {:datastream => @datastream}
    end

    def format_ds_profile_value(ds, key)
      value = ds.profile[key]
      case
      when key == "dsSize" then number_to_human_size(value)
      when key == "dsCreateDate" then value.strftime("%Y-%m-%dT%H:%M:%S.%LZ")
      when key == "dsLocation" && (ds.external? || ds.redirect?) then link_to(value, value)
      else value
      end
    end

  end
end
