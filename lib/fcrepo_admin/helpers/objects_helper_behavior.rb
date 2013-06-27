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
      case
      when prop == :state then object_state
      when [:create_date, :modified_date].include?(prop) then object_date(@object.send(prop))
      when prop == :models then @object.models.join("<br/>").html_safe
      else @object.send(prop)
      end
    end

    def object_date(dt)
      Time.parse(dt).localtime
    end

    def object_state
      state = @object.state
      value = case 
              when state == 'A' then "A (Active)"
              when state == 'I' then "I (Inactive)"
              when state == 'D' then "D (Deleted)"
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
      case
      when item == :pid          then render_object_pid_label
      when item == :summary      then link_to_object item
      when item == :datastreams  then link_to_object item
      when item == :permissions  then link_to_object item, @object.has_permissions? && can?(:permissions, @object)
      when item == :associations then link_to_object item
      when item == :audit_trail  then link_to_object item, @object.auditable? && can?(:audit_trail, @object)
      when item == :object_xml   then link_to_object item
      when item == :solr         then link_to_object item
      else custom_object_nav_item item
      end
    end

    def render_object_pid_label
      content_tag :strong, @object.pid
    end

    def link_to_object(view, condition=true)
      return nil unless condition
      label = t("fcrepo_admin.object.nav.items.#{view}")
      path = case
             when view == :summary      then fcrepo_admin.object_path(@object)
             when view == :datastreams  then fcrepo_admin.object_datastreams_path(@object)
             when view == :permissions  then fcrepo_admin.permissions_object_path(@object)
             when view == :associations then fcrepo_admin.object_associations_path(@object)
             when view == :audit_trail  then fcrepo_admin.audit_trail_object_path(@object)
             when view == :object_xml   then fcrepo_admin.object_path(@object, :format => 'xml')
             when view == :solr         then fcrepo_admin.solr_object_path(@object)
             end
      link_to_unless_current label, path
    end

    def custom_object_nav_item(item)
      # Override this method with your custom item behavior
    end

  end
end
