module FcrepoAdmin
  module ControllerBehavior

    def load_and_authz_object
      load_object
      authorize_object
    end

    def load_object
      @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
    end

    def authorize_object
      #authorize_resource :instance_name => 'object'
      authorize! params[:action].to_sym, @object
    end

    def load_and_authz_datastream
      load_datastream
      authorize_datastream
    end

    def load_datastream
      load_object
      @datastream = @object.datastreams[params[:id]]
    end

    def authorize_datastream
      authorize! params[:action].to_sym, @datastream
    end

  end
end
