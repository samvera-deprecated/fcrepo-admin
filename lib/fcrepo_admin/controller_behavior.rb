module FcrepoAdmin
  module ControllerBehavior

    def load_and_authz_object(param = :object_id)
      load_object param
      authorize_object
    end

    def load_object(param = :object_id)
      @object = ActiveFedora::Base.find(params[param], :cast => true)
    end

    def authorize_object
      authorize! params[:action].to_sym, @object
    end

    def load_and_authz_datastream
      load_datastream
      authorize_datastream
    end

    def load_datastream
      load_object unless @object
      @datastream = @object.datastreams[params[:id]]
    end

    def authorize_datastream
      authorize! params[:action].to_sym, @datastream
    end

  end
end
