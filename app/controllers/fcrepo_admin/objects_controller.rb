module FcrepoAdmin
  class ObjectsController < ApplicationController

    def show
      @object = ActiveFedora::Base.find(params[:id], :cast => true)
      authorize! :read, @object
    end

  end
end
