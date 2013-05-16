module FcrepoAdmin
  class ObjectsController < ApplicationController

    layout 'fcrepo_admin/objects'

    include Hydra::Controller::ControllerBehavior
    include Hydra::PolicyAwareAccessControlsEnforcement
    include FcrepoAdmin::Controller::ControllerBehavior

    before_filter :load_and_authorize_object
    
    def show
    end

    def audit_trail
      if @object.auditable?
        if params[:download] # TODO use format instead download param
          send_data @object.audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
        end
      else
        render :text => I18n.t("fcrepo_admin.object.audit_trail.not_implemented"), :status => 404
      end
    end

    def permissions
    end

  end
end
