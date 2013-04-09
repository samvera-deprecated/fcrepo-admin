module FcrepoAdmin
  class AuditTrailController < ApplicationController
  
    def index
      @object = ActiveFedora::Base.find(params[:object_id], :cast => true)
      # XXX Update when new version of ActiveFedora released
      @audit_trail = @object.respond_to?(:audit_trail) ? @object.audit_trail : @object.inner_object.audit_trail
      if params[:download]
        send_data @audit_trail.to_xml, :disposition => 'inline', :type => 'text/xml'
      end
    end
  
  end
end
