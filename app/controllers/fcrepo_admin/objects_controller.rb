module FcrepoAdmin
  class ObjectsController < ApplicationController
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    def show
      @object = ActiveFedora::Base.find(params[:id], :cast => true)
      authorize! :read, @object
      @properties = {}
      PROPERTIES.each { |p| @properties[p] = @object.send(p) }
    end

  end
end
