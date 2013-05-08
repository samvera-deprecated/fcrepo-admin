module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include FcrepoAdmin::Controller::ControllerBehavior

    helper_method :object_properties

    before_filter :load_and_authorize_object
    
    PROPERTIES = [:owner_id, :state, :create_date, :modified_date, :label]

    def show
    end

    def audit_trail
      if object_is_auditable?
        if params[:download] # TODO use format instead download param
          send_data @object.audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
        end
      else
        render :text => I18n.t("fcrepo_admin.object.audit_trail.not_implemented"), :status => 404
      end
    end

    def permissions
    end

    protected

    def object_properties
      @object_properties ||= PROPERTIES.inject(Hash.new) { |h, p| h[p] = @object.send(p); h }
    end

  end
end
