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
      case item
      when :dsid
        render_datastream_dsid_label
      when :version
        render_datastream_version unless @datastream.current_version?
      when :current_version 
        link_to_datastream item, !@datastream.current_version?, false
      when :summary 
        link_to_datastream item
      when :content
        link_to_datastream item, @datastream.content_is_text?
      when :download
        link_to_datastream item, @datastream.content_is_downloadable?, false
      when :edit
        link_to_datastream item, @datastream.content_is_editable? && can?(:edit, @object)
      when :upload
        link_to_datastream item, @datastream.content_is_uploadable? && can?(:upload, @object)
      when :history
        link_to_datastream item, !@datastream.new?
      else 
        custom_datastream_nav_item item
      end
    end

    def link_to_datastream(view, condition=true, unless_current=true)
      return nil unless condition
      path = case view
             when :current_version
               fcrepo_admin.object_datastream_path(@object, @datastream)
             when :summary       
               fcrepo_admin.object_datastream_path(@object, @datastream, datastream_params)
             when :content         
               fcrepo_admin.content_object_datastream_path(@object, @datastream, datastream_params)
             when :download
               fcrepo_admin.download_object_datastream_path(@object, @datastream, datastream_params)
             when :edit 
               fcrepo_admin.edit_object_datastream_path(@object, @datastream)
             when :upload
               fcrepo_admin.upload_object_datastream_path(@object, @datastream)
             when :history
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
      case alert
      when :system_managed
        if ["DC", "RELS-EXT", "rightsMetadata", "defaultRights"].include?(@datastream.dsid)
          render_datastream_alert(alert, :caution => true)
        end
      when :not_versionable        
        render_datastream_alert(alert, :caution => true) unless @datastream.versionable
      when :inactive
        render_datastream_alert(alert) if @datastream.inactive?
      when :deleted
        render_datastream_alert(alert, :css_class => "alert alert-error") if @datastream.deleted?
      end
    end

    def render_datastream_alert(alert, opts={})
      render :partial => 'alert', :locals => {:alert => alert, :caution => opts.fetch(:caution, false), :css_class => opts.fetch(:css_class, "alert")}
    end

    def format_datastream_state(ds)
      state = ds.dsState
      formatted = case state
                  when 'A'
                    "A (Active)"
                  when 'I'
                    "I (Inactive)"
                  when 'D'
                    "D (Deleted)"
                  end
      formatted
    end

    def format_datastream_control_group(ds)
      control_group = ds.controlGroup
      formatted = case control_group
                  when 'M'
                    "M (Managed)"
                  when 'X'
                    "X (Inline XML)"
                  when 'E'
                    "E (External Referenced)"
                  when 'R'
                    "R (Redirect)"
                  end
      formatted
    end

    def format_datastream_version_id(ds)
      version_id = ds.dsVersionID
      version_id += " (#{t('fcrepo_admin.datastream.current_version')})" if ds.current_version?
      version_id
    end

    def format_datastream_label(ds)
      if ds.dsLabel.blank?
        content_tag(:em, I18n.t('fcrepo_admin.datastream.profile.no_label'))
      else
        ds.dsLabel
      end
    end

    def format_datastream_profile_value(ds, key)
      case key
      when "dsSize"
        number_to_human_size(ds.dsSize)
      when "dsCreateDate"
        ds.dsCreateDate.localtime
      when "dsLabel"
        format_datastream_label(ds)
      when "dsLocation" && ds.content_is_url?
        link_to(ds.dsLocation, ds.dsLocation)
      when "dsState"
        format_datastream_state(ds)
      when "dsControlGroup"
        format_datastream_control_group(ds)
      when "dsVersionID"
        format_datastream_version_id(ds)
      else ds.profile[key]
      end
    end

    def ds_list_css_class(object_or_ds)
      [object_or_ds.safe_pid, "datastreams"].join("-")
    end

    def ds_css_class(ds)
      [ds_list_css_class(ds), ds.dsid].join("-")
    end

    def ds_profile_css_class(ds, attr)
      [ds_css_class(ds), attr].join("-")
    end

  end
end
