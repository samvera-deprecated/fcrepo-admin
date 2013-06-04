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

  end
end
