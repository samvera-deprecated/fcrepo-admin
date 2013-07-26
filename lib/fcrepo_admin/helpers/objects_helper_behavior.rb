module FcrepoAdmin::Helpers
  module ObjectsHelperBehavior

    def object_title
      "#{object_type} #{@object.pid}"
    end

    def object_type
      @object.class.to_s
    end

    def object_properties
      FcrepoAdmin.object_properties.inject(Hash.new) { |hash, prop| hash[prop] = object_property(prop); hash }
    end

    def object_property(prop)
      case prop
      when :state
        object_state
      when :create_date, :modified_date
        object_date(@object.send(prop))
      when :models
        @object.models.join("<br/>").html_safe
      else 
        @object.send(prop)
      end
    end

    def object_date(dt)
      Time.parse(dt).localtime
    end

    def object_state
      state = @object.state
      value = case state
              when 'A'
                "A (Active)"
              when 'I'
                "I (Inactive)"
              when 'D'
                "D (Deleted)"
              end
      value
    end

    def object_show_datastream_columns
      FcrepoAdmin.object_show_datastream_columns
    end

    def object_nav
      render :partial => 'fcrepo_admin/shared/context_nav', :locals => {:header => object_nav_header, :items => object_nav_items}
    end

    def object_nav_header
	  t("fcrepo_admin.object.nav.header")
    end

    def object_nav_items
      FcrepoAdmin.object_nav_items.collect { |item| object_nav_item(item) }.reject { |item| item.nil? }
    end

    def object_nav_item(item)
      case item
      when :pid         
        render_object_pid_label
      when :summary     
        link_to_object item
      when :datastreams 
        link_to_object item
      when :permissions 
        link_to_object item, @object.has_permissions? && can?(:permissions, @object)
      when :associations
        link_to_object item
      when :audit_trail 
        link_to_object item, @object.auditable? && can?(:audit_trail, @object)
      when :object_xml  
        link_to_object item
      when :solr        
        link_to_object item
      when :catalog     
        link_to_object item
      else 
        custom_object_nav_item item
      end
    end

    def render_object_pid_label
      content_tag :strong, @object.pid
    end

    def link_to_object(view, condition=true)
      return nil unless condition
      label = t("fcrepo_admin.object.nav.items.#{view}")
      path = case view
             when :summary     
               fcrepo_admin.object_path(@object)
             when :datastreams 
               fcrepo_admin.object_datastreams_path(@object)
             when :permissions 
               fcrepo_admin.permissions_object_path(@object)
             when :associations
               fcrepo_admin.object_associations_path(@object)
             when :audit_trail 
               fcrepo_admin.audit_trail_object_path(@object)
             when :object_xml  
               fcrepo_admin.object_path(@object, :format => 'xml')
             when :solr        
               fcrepo_admin.solr_object_path(@object)
             when :catalog     
               catalog_path(@object)
             end
      link_to_unless_current label, path
    end

    def custom_object_nav_item(item)
      # Override this method with your custom item behavior
    end

  end
end
