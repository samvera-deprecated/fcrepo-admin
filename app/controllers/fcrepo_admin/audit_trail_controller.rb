module FcrepoAdmin
  class AuditTrailController < ApplicationController

    include FcrepoAdmin::ControllerBehavior

    before_filter :load_and_authz_object
  
    def index
      # XXX Update when new version of ActiveFedora released
      @audit_trail = @object.respond_to?(:audit_trail) ? @object.audit_trail : @object.inner_object.audit_trail
      if params[:download]
        send_data @audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
      end
    end
  
  end
end
