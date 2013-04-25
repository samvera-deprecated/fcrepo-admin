module FcrepoAdmin
  module ControllerBehavior
    extend ActiveSupport::Concern

    included do
      helper_method :object_is_auditable?
    end

    def object_is_auditable?
      begin
        @object && @object.is_a?(ActiveFedora::Auditable)
      rescue
        false
      end
    end

  end
end
