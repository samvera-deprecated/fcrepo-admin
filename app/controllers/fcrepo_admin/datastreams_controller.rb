require 'mime/types'

module FcrepoAdmin
  class DatastreamsController < ApplicationController

    layout 'fcrepo_admin/datastreams', :except => :index
    layout 'fcrepo_admin/objects', :only => :index

    include Hydra::Controller::ControllerBehavior
    include Hydra::PolicyAwareAccessControlsEnforcement
    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    before_filter :load_datastream, :except => :index

    def index
    end

    def show
    end

    def content
      unless @datastream.content_is_text?
        render :text => "Datastream content is not text.", :status => 403
      end
    end

    def history
    end

    def download
      # XXX Replace with Hydra download behavior?
      mimetypes = MIME::Types[@datastream.mimeType]
      send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"                
    end

    def edit
      unless @datastream.content_is_editable?
        render :text => "Datastream content is not editable", :status => 403
      end
    end

    def upload
      unless @datastream.content_is_uploadable?
        render :text => "This datstream does not support file content", :status => 403
      end
    end

    def update
      if params[:file] # file uploaded
        @datastream.content = params[:file].read
      else # content submitted
        @datastream.content = params[:content]
      end
      @object.save
      flash[:notice] = "Datastream content updated." # i18n
      redirect_to fcrepo_admin.object_datastream_url(@object, @datastream)
    end

    private
    
    def load_datastream
      @datastream = @object.datastreams[params[:id]]
      @datastream = @datastream.asOfDateTime(params[:asOfDateTime]) if params[:asOfDateTime]
    end

  end
end

