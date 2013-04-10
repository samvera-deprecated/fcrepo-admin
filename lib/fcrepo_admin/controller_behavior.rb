module FcrepoAdmin
  module ControllerBehavior

    def load_and_authz_object
      @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
      authorize! :read, @object
    end    

  end
end
