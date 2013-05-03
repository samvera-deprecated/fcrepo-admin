module FcrepoAdmin::Helpers
  module ObjectsHelperBehavior
    include FcrepoAdmin::Helpers::FcrepoAdminHelperBehavior

    def object_title
      "#{object_type} #{@object.pid}"
    end

    def object_type
      @object.class.to_s
    end
    
  end
end
