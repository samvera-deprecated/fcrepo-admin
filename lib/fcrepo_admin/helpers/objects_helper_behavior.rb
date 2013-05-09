module FcrepoAdmin::Helpers
  module ObjectsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def object_title
      "#{object_type} #{@object.pid}"
    end

    def object_type
      @object.class.to_s
    end

    def object_properties_keys
      [:owner_id, :state, :create_date, :modified_date, :label]
    end

    def object_properties
      object_properties_keys.inject(Hash.new) { |h, p| h[p] = @object.send(p); h }
    end

    # List of ds profile keys for for object show view
    def object_show_datastream_columns
      ["dsLabel"]
    end
    
  end
end
