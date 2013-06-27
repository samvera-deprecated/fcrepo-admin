module FcrepoAdmin::Helpers
  module DatastreamsHelperBehavior

    def datastream_title
      "#{t('fcrepo_admin.datastream.title')}: #{@datastream.dsid}"
    end

    def datastream_show_profile_keys
      FcrepoAdmin.datastream_show_profile_keys
    end

    def datastream_nav
      render :partial => 'fcrepo_admin/shared/context_nav', :locals => {:header => datastream_nav_header, :items => datastream_nav_items}      
    end

    def datastream_nav_header
      t("fcrepo_admin.datastream.nav.header")
    end

    def datastream_nav_items
      FcrepoAdmin.datastream_nav_items.collect { |item| datastream_nav_item(item) }.reject { |item| item.nil? }
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
      when item == :dsid
        render_datastream_dsid_label
      when item == :version
        render_datastream_version unless @datastream.current_version?
      when item == :current_version 
        link_to_datastream item, !@datastream.current_version?, false
      when item == :summary 
        link_to_datastream item
      when item == :content
        link_to_datastream item, @datastream.content_is_text?
      when item == :download
        link_to_datastream item, @datastream.content_is_downloadable?, false
      when item == :edit
        link_to_datastream item, @datastream.content_is_editable? && can?(:edit, @object)
      when item == :upload
        link_to_datastream item, @datastream.content_is_uploadable? && can?(:upload, @object)
      when item == :history
        link_to_datastream item, !@datastream.new?
      else 
        custom_datastream_nav_item item
      end
    end

    def link_to_datastream(view, condition=true, unless_current=true)
      return nil unless condition
      path = case
             when view == :current_version
               fcrepo_admin.object_datastream_path(@object, @datastream)
             when view == :summary       
               fcrepo_admin.object_datastream_path(@object, @datastream, datastream_params)
             when view == :content         
               fcrepo_admin.content_object_datastream_path(@object, @datastream, datastream_params)
             when view == :download
               fcrepo_admin.download_object_datastream_path(@object, @datastream, datastream_params)
             when view == :edit 
               fcrepo_admin.edit_object_datastream_path(@object, @datastream)
             when view == :upload
               fcrepo_admin.upload_object_datastream_path(@object, @datastream)
             when view == :history
               fcrepo_admin.history_object_datastream_path(@object, @datastream)
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

    def render_datastream_dsid_label
      content_tag :strong, @datastream.dsid
    end

    def datastream_alerts(*alerts)
      rendered = ""
      alerts.each do |alert|
        content = datastream_alert(alert)
        rendered << content unless content.nil?
      end
      rendered.html_safe
    end

    def datastream_alert(alert)
      case
      when alert == :system_managed
        if ["DC", "RELS-EXT", "rightsMetadata", "defaultRights"].include?(@datastream.dsid)
          render_datastream_alert(alert, :caution => true)
        end
      when alert == :not_versionable        
        render_datastream_alert(alert, :caution => true) unless @datastream.versionable
      when alert == :inactive
        render_datastream_alert(alert) if @datastream.inactive?
      when alert == :deleted
        render_datastream_alert(alert, :css_class => "alert alert-error") if @datastream.deleted?
      end
    end

    def render_datastream_alert(alert, opts={})
      render :partial => 'alert', :locals => {:alert => alert, :caution => opts.fetch(:caution, false), :css_class => opts.fetch(:css_class, "alert")}
    end

    def format_datastream_state(ds)
      state = ds.dsState
      formatted = case 
                  when state == 'A' then "A (Active)"
                  when state == 'I' then "I (Inactive)"
                  when state == 'D' then "D (Deleted)"
                  end
      formatted
    end

    def format_datastream_control_group(ds)
      control_group = ds.controlGroup
      formatted = case
                  when control_group == 'M' then "M (Managed)"
                  when control_group == 'X' then "X (Inline XML)"
                  when control_group == 'E' then "E (External Referenced)"
                  when control_group == 'R' then "R (Redirect)"
                  end
      formatted
    end

    def format_datastream_version_id(ds)
      version_id = ds.dsVersionID
      version_id += " (#{t('fcrepo_admin.datastream.current_version')})" if ds.current_version?
      version_id
    end

    def format_datastream_profile_value(ds, key)
      case
      when key == "dsSize" then number_to_human_size(ds.dsSize)
      when key == "dsCreateDate" then ds.dsCreateDate.localtime
      when key == "dsLocation" && ds.content_is_url? then link_to(ds.dsLocation, ds.dsLocation)
      when key == "dsState" then format_datastream_state(ds)
      when key == "dsControlGroup" then format_datastream_control_group(ds)
      when key == "dsVersionID" then format_datastream_version_id(ds)
      else ds.profile[key]
      end
    end

  end
end
