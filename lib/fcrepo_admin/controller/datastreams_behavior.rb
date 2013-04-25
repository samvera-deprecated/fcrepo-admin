require 'mime/types'

module FcrepoAdmin::Controller
  module DatastreamsBehavior
    extend ActiveSupport::Concern

    included do
      layout 'fcrepo_admin/datastreams'
      include FcrepoAdmin::Controller::ControllerBehavior
      before_filter :load_and_authorize_datastream
      before_filter :inline_filter, :only => [:show, :edit]
    end

    # Additional types of content that should be displayed inline
    TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']
    MAX_INLINE_SIZE = 1024 * 64

    def show
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

    def load_and_authorize_datastream
      load_object
      load_datastream
      authorize_datastream
    end
    
    def load_object
      @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
    end

    def load_datastream
      @datastream = @object.datastreams[params[:id]]
    end

    def authorize_datastream
      action = case params[:action]
               when 'upload'
                 :edit
               when 'download'
                 :read
               else
                 params[:action].to_sym
               end
      # Datastream permissions are solely based on object permissions
      authorize! action, @object
    end

    protected

    def inline_filter
      @inline = (@datastream.mimeType.start_with?('text/') || TEXT_MIME_TYPES.include?(@datastream.mimeType)) && @datastream.dsSize <= MAX_INLINE_SIZE
    end

  end
end

