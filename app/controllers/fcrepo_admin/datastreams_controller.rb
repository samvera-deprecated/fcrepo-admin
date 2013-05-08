require 'mime/types'

module FcrepoAdmin
  class DatastreamsController < ApplicationController

    layout 'fcrepo_admin/datastreams', :except => :index
    layout 'fcrepo_admin/objects', :only => :index

    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    before_filter :load_datastream, :except => :index

    helper_method :ds_content_is_text?
    helper_method :ds_content_is_editable?

    # Additional types of content that should be displayed inline
    TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']
    MAX_INLINE_SIZE = 1024 * 64

    def index
    end

    def show
    end

    def content
    end

    def history
    end

    def download
      mimetypes = MIME::Types[@datastream.mimeType]
      send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"                
    end

    def edit
    end

    def upload
    end

    def update
      if params[:file] # file uploaded
        @datastream.content = params[:file].read
      else # content submitted
        @datastream.content = params[:content]
      end
      @object.save
      flash[:notice] = "Datastream content updated." # i18n
      redirect_to fcrepo_admin.object_datastream_url(@object, @datastream.dsid)
    end

    private
    
    def load_datastream
      @datastream = @object.datastreams[params[:id]]
      @datastream = @datastream.asOfDateTime(params[:asOfDateTime]) if params[:asOfDateTime]
    end

    protected

    def ds_content_is_text?
      @datastream.mimeType.start_with?('text/') || TEXT_MIME_TYPES.include?(@datastream.mimeType)
    end

    def ds_content_is_editable?
      @datastream.new? || (ds_content_is_text? && (@datastream.dsSize <= MAX_INLINE_SIZE))
    end

  end
end

