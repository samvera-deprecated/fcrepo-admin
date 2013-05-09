module FcrepoAdmin::Helpers
  module FcrepoAdminHelperBehavior

    def object_has_permissions?
      @object.is_a?(Hydra::ModelMixins::RightsMetadata)
    end

    def object_context_nav_header
	  t("fcrepo_admin.object.nav.header")
    end

    def object_context_nav_items
      render :partial => 'fcrepo_admin/objects/context_nav_items', :locals => {:object => @object}
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
