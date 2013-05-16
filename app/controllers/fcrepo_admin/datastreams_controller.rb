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

    helper_method :ds_is_current_version?
    helper_method :ds_content_is_text?
    helper_method :ds_content_is_editable?
    helper_method :ds_content_is_uploadable?

    # TODO Migrate to config initializer
    EXTRA_TEXT_MIME_TYPES = ['application/xml', 'application/rdf+xml', 'application/json']
    MAX_EDITABLE_SIZE = 1024 * 64

    def index
    end

    def show
    end

    def content
    end

    def history
    end

    def download
      # XXX Replace with Hydra download behavior?
      mimetypes = MIME::Types[@datastream.mimeType]
      send_data @datastream.content, :disposition => 'attachment', :type => @datastream.mimeType, :filename => "#{@datastream.pid.sub(/:/, '_')}_#{@datastream.dsid}.#{mimetypes.first.extensions.first}"                
    end

    def edit
    end

    def upload
      unless ds_content_is_uploadable?
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

    protected

    # XXX Use Rubydora::Datastream#current_version? when it becomes available
    # https://github.com/projecthydra/rubydora/pull/25
    def ds_is_current_version?
      @current_version ||= (@datastream.new? || @datastream.dsVersionID == @datastream.versions.first.dsVersionID)
    end

    def ds_content_is_url?
      @datastream.external? || @datastream.redirect?
    end

    def ds_content_is_editable?
      !ds_content_is_url? && ds_content_is_text? && ds_editable_content_size_ok?
    end

    def ds_editable_content_size_ok?
      @datastream.dsSize <= MAX_EDITABLE_SIZE
    end

    def ds_content_is_uploadable?
      @datastream.managed? || @datastream.inline?
    end

    private

    def ds_content_is_text?
      mimetype_is_text(@datastream.mimeType)
    end

    def mimetype_is_text(mimetype)
      return false if mimetype.blank?
      mimetype.start_with?('text/') || EXTRA_TEXT_MIME_TYPES.include?(mimetype)
    end

  end
end

