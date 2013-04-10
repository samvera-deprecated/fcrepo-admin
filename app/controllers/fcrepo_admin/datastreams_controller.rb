require 'mime/types'

module FcrepoAdmin
  class DatastreamsController < ApplicationController
    
    include FcrepoAdmin::ControllerBehavior

    TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']

    before_filter :load_and_authz_object

    def index
      # @object loaded and authz'd by before_filter
    end
  
    def show
      @datastream = @object.datastreams[params[:id]]
      @inline = @datastream.mimeType.start_with?('text/') || TEXT_MIME_TYPES.include?(@datastream.mimeType)
    end

    def download
      @datastream = @object.datastreams[params[:id]]
      mimetypes = MIME::Types[@datastream.mimeType]
      send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"        
    end

  end
end

