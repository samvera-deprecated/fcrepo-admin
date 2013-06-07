require 'mime/types'

module FcrepoAdmin
  class DownloadController < ApplicationController

    include Hydra::Controller::DownloadBehavior

    protected

    def load_asset
      @asset = ActiveFedora::Base.load_instance_from_solr(params[:object_id])
    end

    def datastream_to_show
      asset.datastreams[params[:id]]
    end

    # Pattern: pid__dsid.ext (replacing colon in pid with underscore)
    def datastream_name
      "#{datastream.pid.sub(/:/, '_')}__#{datastream.dsid}.#{datastream_extension}"
    end

    private

    def datastream_extension
      MIME::Types[datastream.mimeType].first.extensions.first rescue 'bin'
    end

  end
end
