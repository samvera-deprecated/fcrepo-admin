require 'mime/types'

module FcrepoAdmin
  class DatastreamsController < ApplicationController

    # include FcrepoAdmin::ControllerBehavior

    layout 'fcrepo_admin/datastreams'

    # Additional types of content that should be displayed inline
    TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']

    # before_filter :load_and_authorize_object, :only => :index
    before_filter :load_and_authorize_datastream # , :except => :index
    # before_filter :load_datastream, :only => :download
    before_filter :inline_filter, :only => [:show, :edit]

    # def index
    # end
  
    def show
      if params[:download]
        mimetypes = MIME::Types[@datastream.mimeType]
        send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"                
      end
    end

    # def download
    #   mimetypes = MIME::Types[@datastream.mimeType]
    #   send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"        
    # end

    def edit
    end

    def update
      if params[:file]
        @datastream.content = params[:file].read
      else
        @datastream.content = params[:content]
      end
      @object.save
      flash[:notice] = "Datastream content updated."
      redirect_to fcrepo_admin.object_datastream_url(@object, @datastream.dsid)
    end

    private

    def load_and_authorize_datastream
      load_datastream
      authorize_datastream
    end

    def load_datastream
      @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
      @datastream = @object.datastreams[params[:id]]
    end

    def authorize_datastream
      # Datastream permissions are solely based on object permissions
      authorize! params[:action].to_sym, @object
    end

    protected

    def inline_filter
      @inline = @datastream.mimeType.start_with?('text/') || TEXT_MIME_TYPES.include?(@datastream.mimeType)
    end

  end
end

