require 'mime/types'

module FcrepoAdmin
  class DatastreamsController < ApplicationController

    include FcrepoAdmin::ControllerBehavior
    # include CanCan::ControllerAdditions

    TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']

    before_filter :load_and_authz_object, :only => :index
    before_filter :load_and_authz_datastream, :except => :index
    before_filter :inline_filter, :only => [:show, :edit]

    def index
    end
  
    def show
    end

    def download
      mimetypes = MIME::Types[@datastream.mimeType]
      send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"        
    end

    def edit
    end

    def update
      if params[:file]
        File.open(params[:file], 'rb') do |f|
          # FIXME read in chunks
          @datastream.content = f.read
        end
      else
        @datastream.content = params[:content]
      end
      @object.save
      flash[:notice] = "Datastream content updated."
      redirect_to fcrepo_admin.object_datastream_url(@object, @datastream.dsid)
    end

    protected

    def inline_filter
      @inline = @datastream.mimeType.start_with?('text/') || TEXT_MIME_TYPES.include?(@datastream.mimeType)
    end

  end
end

