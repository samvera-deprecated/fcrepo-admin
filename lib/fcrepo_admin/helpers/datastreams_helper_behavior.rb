module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior

    def datastream_title
      "#{t('fcrepo_admin.datastream.title')}: #{@datastream.dsid}"
    end

    def datastream_nav
      render :partial => 'fcrepo_admin/shared/context_nav', :locals => {:header => datastream_nav_header, :items => datastream_nav_items}      
    end

    def datastream_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_nav_items
      FcrepoAdmin.datastream_nav_items.collect do |item| 
        content = datastream_nav_item(item)
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

    def datastream_nav_item(item)
      case
      when item == :version_label   then render_datastream_version unless @datastream.current_version?
      when item == :current_version then link_to_datastream item, !@datastream.current_version?, false
      when item == :summary         then link_to_datastream item
      when item == :content         then link_to_datastream item, @datastream.content_is_text?
      when item == :download        then link_to_datastream item, @datastream.content_is_downloadable?, false
      when item == :edit            then link_to_datastream item, @datastream.content_is_editable? && can?(:edit, @object)
      when item == :upload          then link_to_datastream item, @datastream.content_is_uploadable? && can?(:upload, @object)
      when item == :history         then link_to_datastream item, !@datastream.new?
      else custom_datastream_nav_item item
      end
    end

    def link_to_datastream(view, condition=true, unless_current=true)
      return nil unless condition
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
      unless_current ? link_to_unless_current(label, path) : link_to(label, path)
    end

    def custom_datastream_nav_item(item)
      # Override this method with your custom item behavior
    end

    def link_to_datastream_version(dsVersion)
      link_to_unless dsVersion.current_version?, dsVersion.dsVersionID, fcrepo_admin.object_datastream_path(@object, @datastream, :asOfDateTime => dsVersion.asOfDateTime) do |name|
        "#{name} (current version)"
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
